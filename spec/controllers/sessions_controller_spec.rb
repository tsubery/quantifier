require "active_support/all"
require "rails_helper"
describe SessionsController, :omniauth do
  before do
    request.env["omniauth.auth"] = mock_auth
  end

  describe "#create" do
    it "creates a user" do
      expect do
        post :create, params: { provider: :twitter }
      end.to change { User.count }.by(1)
    end

    it "creates a session" do
      expect(session[:beeminder_user_id]).to be_nil
      post :create, params: { provider: :twitter }
      expect(session[:beeminder_user_id]).not_to be_nil
    end

    it "redirects to the home page" do
      post :create, params: { provider: :twitter }
      expect(response).to redirect_to root_url
    end
  end

  describe "#destroy" do
    before do
      post :create, params: { provider: :twitter }
    end

    it "resets the session" do
      expect(session[:beeminder_user_id]).not_to be_nil
      delete :destroy
      expect(session[:beeminder_user_id]).to be_nil
    end

    it "redirects to the home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end
end
