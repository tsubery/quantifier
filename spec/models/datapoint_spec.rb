require "rails_helper"

describe Datapoint do
  ts = Time.zone.at(0)

  context "equality" do
    shared_examples "equal as can be" do |dp1, dp2|
      it "#==" do
        expect(dp1).to eq(dp2)
      end

      it "#.hash" do
        expect(dp1.hash).to eq(dp2.hash)
      end

      it "#.eql?" do
        expect(dp1.eql?(dp2)).to be true
      end

      it "can be subtracted from array" do
        expect([dp1] - [dp2]).to be_empty
      end
    end
    context "When value has different type" do
      it_behaves_like "equal as can be",
                      Datapoint.new(value: 1, timestamp: ts),
                      Datapoint.new(value: 1.0, timestamp: ts)
    end

    context "When id has different type" do
      it_behaves_like "equal as can be",
                      Datapoint.new(id: "1", value: 1, timestamp: ts),
                      Datapoint.new(id: 1, value: 1, timestamp: ts)
    end

    context "Value accuracy" do
      # This test verify floating point accuracy subtlties does not cause inequality
      it_behaves_like "equal as can be",
                      Datapoint.new(value: (0.1 + 0.2), timestamp: ts),
                      Datapoint.new(value: 0.3, timestamp: ts)
    end
  end
end
