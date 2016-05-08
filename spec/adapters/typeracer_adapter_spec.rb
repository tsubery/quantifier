require "rails_helper"
describe TrelloAdapter do
  let(:subject) { TrelloAdapter }

  describe "validations" do
    context "when credentials missing token" do
      let(:credentials) { { secret: "secret" } }

      it "is invalid" do
        expect(subject.valid_credentials?(credentials)).to be false
      end

      it "Raise error on instantiation" do
        error_klass = BaseAdapter::InvalidCredentials
        expect { subject.new(credentials) }.to raise_error(error_klass)
      end
    end

    context "when credentials missing secret" do
      let(:credentials) { { token: "token" } }

      it "is invalid" do
        expect(subject.valid_credentials?(credentials)).to be false
      end

      it "Raise error on instantiation" do
        error_klass = BaseAdapter::InvalidCredentials
        expect { subject.new(credentials) }.to raise_error(error_klass)
      end
    end

    context "When credentials have token and secret" do
      let(:credentials) { { token: "t", secret: "s" } }

      it "is valid" do
        expect(subject.valid_credentials?(credentials)).to be true
      end

      it "Does not raise error on instantiation" do
        expect { subject.new(credentials) }.not_to raise_error
      end
    end
  end
end
