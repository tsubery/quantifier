require 'active_support/all'
require_relative '../../app/adapters/googlefit_adapter'
describe GooglefitAdapter do
  let(:subject) { GooglefitAdapter }

  describe "validations" do
    context "when credentials missing token" do
      let(:credentials) { { } }

      it "is invalid" do
        expect(subject.valid_credentials?(credentials)).to be false
      end

      it "Raise error on instantiation" do
        expect{subject.new(credentials)}.to raise_error(BaseAdapter::InvalidCredentials)
      end
    end

    context "When credentials have token" do
      let(:credentials) { { token: "sometoken" } }

      it "is valid" do
        expect(subject.valid_credentials?(credentials)).to be true
      end

      it "Does not raise error on instantiation" do
        expect{subject.new(credentials)}.not_to raise_error
      end
    end
  end
end
