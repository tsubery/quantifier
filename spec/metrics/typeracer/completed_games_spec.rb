require "rails_helper"

describe "Days backlog" do
  let(:subject) { PROVIDERS[:typeracer].find_metric(:completed_games) }

  let(:start_ts) { Time.zone.parse("2015-01-01") }

  context "when there are 5 completed games" do
    it "returns 5" do
      Timecop.freeze(start_ts) do
        expect(adapter = double).to receive(:completed_games).and_return(5)

        expect(subject.call(adapter)).to eq(
          Datapoint.new(timestamp: nil, value: 5)
        )
      end
    end
  end
  context "when there are 33 completed games" do
    it "returns 33" do
      Timecop.freeze(start_ts) do
        expect(adapter = double).to receive(:completed_games).and_return(33)

        expect(subject.call(adapter)).to eq(
          Datapoint.new(timestamp: nil, value: 33)
        )
      end
    end
  end
end
