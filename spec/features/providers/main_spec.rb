require "rails_helper"
feature "Home page" do
  context "anonymouse user" do
    scenario "redirected to root" do
      visit root_path
      expect(page.current_path).to eq(root_path)
    end
  end
end
