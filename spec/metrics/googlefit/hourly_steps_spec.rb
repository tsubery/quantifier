require "rails_helper"

describe "Hourly step" do
  let(:subject) { PROVIDERS[:googlefit].find_metric(:hourly_steps) }

  def make_point(timestamp, value)
    double start_time_nanos: (timestamp.to_i * 1_000_000_000),
           value: [double(int_val: value)]
  end

  describe "calculating steps" do
    context "when there were no steps" do
      it "returns empty results" do
        adapter = double fetch_steps: []
        expect(subject.call(adapter)).to be_empty
      end
    end
    context "when there were three walks in two hours" do
      it "returns two results" do
        start_ts = Time.zone.parse("2015-09-10")
        points = [
          make_point((start_ts + 0.minutes), 100),
          make_point((start_ts + 59.minutes), 50),
          make_point((start_ts + 90.minutes), 200),
        ]

        adapter = double fetch_steps: points
        results = subject.call(adapter)
        expect(results.count).to eq(2)
        first_dp = Datapoint.new(timestamp: start_ts,
                                 value: 150,
                                 unique: true)
        expect(results[0]).to eq(first_dp)

        second_dp = Datapoint.new(timestamp: (start_ts + 60.minutes),
                                  value: 200,
                                  unique: true)
        expect(results[1]).to eq(second_dp)
      end
    end
  end
end
