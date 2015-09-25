require "rails_helper"

describe "Home page" do
  scenario "anonymous user logs in to the app" do
    visit root_path
    expect(page).to have_content("Welcome")
    expect(page).to have_content("sign in")

    mock_auth
    click_link "Sign in"
    expect(page.current_path).to eq(root_path)
    expect(@page).not_to have_content("Please sign in")
    expect(@page).not_to have_content("Welcome")
    expect(page).to have_content("Reload")
    click_link "Reload"
    expect(page).to have_content("Scores updated")
    expect(page.current_path).to eq(root_path)
  end
end
