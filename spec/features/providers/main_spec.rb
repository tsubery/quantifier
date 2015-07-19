feature 'Home page' do
  context "anonymouse user" do
    scenario "redirected to root" do
      visit providers_path
      expect(page.current_path).to eq(root_path)
    end
  end

  scenario 'New User' do
    mock_current_user create(:user)
    visit providers_path
    expect(page).to have_content 'Connect your pocket account'
    expect(page).to have_content 'Connect your typeracer account'

    set_mock_auth :pocket
    page.click_link('Connect your pocket account')
    expect(page).to have_content 'configure mock_uid@pocket'
    expect(page).to have_content 'Connect your typeracer account'

  end
end
