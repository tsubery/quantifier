feature "Home page" do
  context "anonymouse user" do
    scenario "redirected to root" do
      visit providers_path
      expect(page.current_path).to eq(root_path)
    end
  end
end
