require "rails_helper"

describe "Days backlog" do
  let(:subject) { PROVIDERS[:trello].find_metric(:idle_days_linear) }
  let(:list_ids) { %w(list1 list2) }
  let(:options) { { list_ids: list_ids } }

  context "when there are 5 cards from the last 5 days" do
    let(:start_ts) { Time.zone.parse("2015-01-01") }

    it "calculates 15" do
      Timecop.freeze(start_ts) do
        cards = (1..5).map do |i|
          double last_activity_date: i.days.ago
        end
        expect(adapter = double).to receive(:cards)
          .with(list_ids).and_return(cards)

        expect(subject.call(adapter, options)).to eq(
          Datapoint.new(timestamp: nil, value: 15)
        )
      end
    end

    it "calculates 50 a week later" do
      Timecop.freeze(start_ts) do
        cards = (1..5).map do |i|
          double last_activity_date: (7 + i).days.ago
        end
        expect(adapter = double).to receive(:cards)
          .with(list_ids).and_return(cards)

        expect(subject.call(adapter, options)).to eq(
          Datapoint.new(timestamp: nil, value: 50)
        )
      end
    end

    it "rounds down to avoid fractions" do
      Timecop.freeze(start_ts) do
        cards = [double(last_activity_date: 47.hours.ago)]
        expect(adapter = double).to receive(:cards)
          .with(list_ids).and_return(cards)
        expect(subject.call(adapter, options)).to eq(
          Datapoint.new(timestamp: nil, value: 1)
        )
      end
    end
  end
end
