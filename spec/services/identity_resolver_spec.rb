require_relative "../../app/services/identity_resolver"

describe IdentityResolver do
  let(:resolver) { IdentityResolver.new current_user, auth }
  let(:user_id) { "mee" }
  let(:token) { "nekot" }

  describe "creating a new session" do
    let(:auth) do
      {
        "provider" => "beeminder",
        "uid" => user_id,
        "credentials" => {
          "token" => token
        }
      }.with_indifferent_access
    end

    context "when session does not exists" do
      let(:current_user) { nil }

      context "when the user is new" do
        it "set's correct flash message" do
          expect(resolver.flash).to eq("Signed in!")
        end
        it "inserts a new user" do
          user = resolver.sign_in_user
          expect(user).to be_kind_of(User)
          expect(user.beeminder_token).to eq(token)
          expect(user).to be_persisted
        end
      end
      context "when the user exists" do
        it "set's correct flash message" do
          expect(resolver.flash).to eq("Signed in!")
        end

        it "updates to token" do
          preexisting_user = create :user,
                                    beeminder_token: "previous_token",
                                    beeminder_user_id: user_id

          user = resolver.sign_in_user
          expect(user.id).to eq(preexisting_user.id)
          expect(user.beeminder_token).to eq(token)
          expect(user).to be_persisted
        end
      end
    end

    context "when session already exists" do
      let(:current_user) { double }

      it "notifies user" do
        expect(resolver.flash).to eq("Already signed in!")
      end
      it "does not expose user" do
        expect(resolver.sign_in_user).to be_nil
      end
    end
  end

  describe "creating new providers" do
    let(:auth) do
      {
        "provider" => "pocket",
        "uid" => user_id,
        "credentials" => {
          "token" => token
        },
        "info" => { "in" => "fo" },
        "extra" => { "ex" => "tra" }
      }.with_indifferent_access
    end
    context "when provider is new" do
      context "and a user is logged in" do
        let(:current_user) { create :user }

        it "set's correct flash message" do
          expect(resolver.flash).to eq("Connected successfully.")
        end
        it "add provider to the signed in user" do
          expect(resolver.sign_in_user).to be_nil # there is no need to sign in again
          provider = current_user.providers.where(
            name: auth.fetch("provider"),
            uid: auth.fetch("uid")
          ).first
          expect(provider).not_to be_nil
          expect(provider.credentials).to eq(auth["credentials"])
          expect(provider.extra).to eq(auth["extra"])
          expect(provider.info).to eq(auth["info"])
        end
      end
      context "and a user is not logged in" do
        let(:current_user) { nil }

        it "set's correct flash message" do
          expect(resolver.flash).to eq("Please sign in first.")
        end
        it "And doesn't set user" do
          expect(resolver.sign_in_user).to be_nil
        end
      end
    end

    context "when provider is known" do
      let!(:provider) { create :provider, uid: user_id }

      context "and its user is not logged in" do
        let(:current_user) { nil }

        it "sets correct flash message" do
          expect(resolver.flash).to eq("Signed in!")
        end
        it "sets the provider user as signed in" do
          expect(resolver.sign_in_user).to eq(provider.user)
        end
      end
      context "and its user is logged in" do
        let(:current_user) { provider.user }

        it "set's correct flash message" do
          expect(resolver.flash).to eq("Provider already connected.")
        end
        it "And doesn't set user" do
          expect(resolver.sign_in_user).to be_nil
        end
      end
      context "and a different user is logged in" do
        let(:current_user) { double }

        it "set's correct flash message" do
          expect(resolver.flash).to eq("User #{user_id} belongs to another user.")
        end
        it "And doesn't set user" do
          expect(resolver.sign_in_user).to be_nil
        end
      end
    end
  end
end
