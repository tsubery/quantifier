require "rails_helper"

describe IdentityResolver do
  let(:resolver) { IdentityResolver.new current_user, auth }
  let(:token) { "nekot" }

  def resolve(current_user, auth)
    IdentityResolver.new(current_user, auth).credential
  end

  describe "when credentials exist" do
    let(:c) { create(:credential) }
    let(:auth) do
      { "uid" => c.uid,
        "provider" => c.provider_name }
    end

    context "when no user is logged in" do
      it "finds it" do
        session_user = nil
        expect(resolve(session_user, auth)).to eq(c)
      end
    end

    context "when the owner is logged in" do
      let(:session_user) { c.user }
      it "finds it" do
        session_user = c.user
        expect(resolve(session_user, auth)).to eq(c)
      end
    end

    context "when another user is logged in" do
      it "finds it" do
        session_user = create :user
        expect(resolve(session_user, auth)).to eq(c)
      end
    end
  end

  describe "when credentials are new" do
    context "and no user is logged in" do
      let(:session_user) { nil }
      context "when provider is beeminder" do
        let(:auth) do
          { "provider" => "beeminder",
            "uid" => "fictitious_user" }
        end
        it "creates a new credential" do
          c = nil
          expect do
            c = resolve(session_user, auth)
          end.to change(Credential, :count).by(1)
          expect(c).to be_persisted
          expect(c.provider_name).to eq(auth["provider"])
          expect(c.uid).to eq(auth["uid"])
          expect(c.user.beeminder_user_id).to eq(auth["uid"])
        end
      end

      context "when provider is not beeminder" do
        let(:auth) do
          { "provider" => "pocket",
            "uid" => "fictitious_user" }
        end
        it "does not create a new credential" do
          c = 1
          expect do
            c = resolve(session_user, auth)
          end.not_to change(Credential, :count)
          expect(c).to be_nil
        end
      end
    end
    context "when a user is logged in" do
      let(:session_user) { create(:user) }
      let(:auth) do
        { "provider" => "pocket",
          "uid" => "fictitious_user" }
      end
      it "creates him a new credential" do
        c = nil
        expect do
          c = resolve(session_user, auth)
        end.to change(Credential, :count).by(1)
        expect(c).to be_persisted
        expect(c.provider_name).to eq(auth["provider"])
        expect(c.uid).to eq(auth["uid"])
        expect(c.user).to eq(session_user)
      end
    end
  end
end
