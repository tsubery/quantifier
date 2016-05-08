require "rails_helper"

describe "Days backlog" do
  let(:subject) { PROVIDERS[:pocket].find_metric(:article_days_linear) }

  context "when there are 5 articles from the last 5 days" do
    let(:start_ts) { Time.zone.parse("2015-01-01") }

    it "calculates 15" do
      Timecop.freeze(start_ts) do
        articles = (1..5).map do |i|
          { "time_added" => i.days.ago }
        end
        adapter = double articles: articles
        expect(subject.call(adapter)).to eq(
          Datapoint.new(timestamp: nil, value: 15)
        )
      end
    end

    it "calculates 50 a week later" do
      Timecop.freeze(start_ts) do
        articles = (1..5).map do |i|
          { "time_added" => (7 + i).days.ago }
        end
        adapter = double articles: articles
        expect(subject.call(adapter)).to eq(
          Datapoint.new(timestamp: nil, value: 50)
        )
      end
    end

    it "rounds down to avoid fractions" do
      Timecop.freeze(start_ts) do
        adapter = double articles: [{ "time_added" => 47.hours.ago }]
        expect(subject.call(adapter)).to eq(
          Datapoint.new(timestamp: nil, value: 1)
        )
      end
    end
  end
end
