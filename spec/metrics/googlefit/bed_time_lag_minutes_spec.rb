require "rails_helper"

describe "Bed time lag" do
  let(:subject) { PROVIDERS[:googlefit].find_metric(:bed_time_lag_minutes) }

  start_ts = Time.zone.parse("2015-09-10")
  def make_point(timestamp, value = 1)
    # tz = ActiveSupport::TimeZone.new("UTC")
    double start_time_nanos: (timestamp.to_i * 1_000_000_000),
           value: [double(int_val: value)]
  end

  let(:tz) { ActiveSupport::TimeZone.new(params["timezone"]) }
  describe "calculating lag" do
    context "when there is not timezone" do
      it "returns empty results" do
        adapter = double fetch_sleeps: [make_point(start_ts, 1)]
        result = subject.call(adapter, {})
        expect(result.value).to eq("Please configure timezone and reload page")

      end
    end
    context "where there were sleeps" do
      context "two sleeps in one day" do
        let(:params) do
          {
            "timezone": "Dublin",
            "bed_time_hour": 22,
            "bed_time_minute": 0,
          }.with_indifferent_access
        end
        it "returns two results" do
          points = [
            make_point((start_ts + 23.hours)),
            make_point((start_ts + 21.hours)),
          ]

          adapter = double fetch_sleeps: points
          results = subject.call(adapter, params)
          expect(results.count).to eq(1)
          first_dp = Datapoint.new(timestamp: tz.at(start_ts).beginning_of_day,
                                   value: 0,
                                   unique: true)
          expect(results[0]).to eq(first_dp)
        end
      end
      context "two sleeps in two days" do
        let(:params) do
          {
            "timezone": "UTC",
            "bed_time_hour": 22,
            "bed_time_minute": 30,
          }.with_indifferent_access
        end
        it "returns two results" do
          points = [
            make_point((start_ts + 22.hours + 29.minutes)),
            make_point((start_ts + 1.day + 22.hours + 31.minutes)),
          ]

          adapter = double fetch_sleeps: points
          results = subject.call(adapter, params)
          expect(results.count).to eq(2)
          first_dp = Datapoint.new(timestamp: start_ts,
                                   value: 0,
                                   unique: true)
          expect(results[0]).to eq(first_dp)

          second_dp = Datapoint.new(timestamp: (start_ts + 1.day),
                                    value: 1,
                                    unique: true)
          expect(results[1]).to eq(second_dp)
        end
      end
      context "Sleep after midnight" do
        let(:params) do
          {
            "timezone": "UTC",
            "bed_time_hour": 23,
            "bed_time_minute": 59,
          }.with_indifferent_access
        end
        it "assigns it to the previous day" do
          points = [
            make_point((start_ts + 1.day + 11.hours + 58.minutes)),
          ]

          adapter = double fetch_sleeps: points
          results = subject.call(adapter, params)
          expect(results.count).to eq(1)
          first_dp = Datapoint.new(timestamp: start_ts,
                                   value: 11 * 60 + 59,
                                   unique: true)
          expect(results[0]).to eq(first_dp)
        end
      end
      context "In a different timezone" do
        let(:params) do
          {
            "timezone": "Hawaii",
            "bed_time_hour": 21,
            "bed_time_minute": 0,
          }.with_indifferent_access
        end
        it "assigns it to the previous day" do
          hawaii_ts = tz.parse("2015-09-27").beginning_of_day
          points = [
            make_point(hawaii_ts + 21.hours + 18.minutes),
          ]

          adapter = double fetch_sleeps: points
          Timecop.freeze(start_ts) do
            results = subject.call(adapter, params)
            expect(results.count).to eq(1)
            first_dp = Datapoint.new(timestamp: hawaii_ts.beginning_of_day,
                                     value: 18,
                                     unique: true)
            expect(results[0]).to eq(first_dp)
          end
        end
      end
    end
  end
end
