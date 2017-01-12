require "rails_helper"

describe "Compose goals metric" do
  let(:subject) { PROVIDERS[:beeminder].find_metric(:compose_goals) }

  context "params validations" do
    it "requires slug_sources key" do
      errors = subject.param_errors({})
      expect(errors.first).to match(/source_slugs hash/i)
    end
    context "when slug_sources exists" do
      it "accepts empty hash" do
        params = { "source_slugs" => {

        } }
        errors = subject.param_errors(params)
        expect(errors).to be_empty
      end
      it "rejects long slugs" do
        params = {
          "source_slugs" => {
            "a" * 251 => "1",
          },
        }
        errors = subject.param_errors(params)
        expect(errors.first).to match(/Slug too long/i)
      end
      it "rejects non numeric factors" do
        params = {
          "source_slugs" => {
            "aasdf" => "nan",
          },
        }
        errors = subject.param_errors(params)
        expect(errors.first).to match(/must be numbers/i)
      end
    end
  end
end
