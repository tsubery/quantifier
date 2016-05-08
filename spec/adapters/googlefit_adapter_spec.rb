require "rails_helper"

describe GooglefitAdapter do
  let(:subject) { GooglefitAdapter }
  let(:bad_credentials) { BaseAdapter::InvalidCredentials }
  let(:bad_auth) { BaseAdapter::AuthorizationError }

  describe "validations" do
    context "when credentials missing token" do
      let(:credentials) { {} }

      it "is invalid" do
        expect(subject.valid_credentials?(credentials)).to be false
      end

      it "Raise error on instantiation" do
        expect { subject.new(credentials) }.to raise_error(bad_credentials)
      end
    end

    context "When credentials have token" do
      let(:credentials) { { token: "sometoken" } }

      it "is valid" do
        expect(subject.valid_credentials?(credentials)).to be true
      end

      it "Does not raise error on instantiation" do
        expect { subject.new(credentials) }.not_to raise_error
      end
    end
  end
  describe "When there is problem with authorization" do
    it "returns our internal authorization error" do
      adapter = subject.new(token: "bad token")
      google_bad_auth = Signet::AuthorizationError.new({})
      allow(adapter).to receive(:authorization).with(no_args)
        .and_raise(google_bad_auth)
      expect do
        adapter.fetch_steps
      end.to raise_error do |error|
        expect(error).to be_kind_of(bad_auth)
        expect(error.cause).to eq(google_bad_auth)
      end
    end
  end
end
