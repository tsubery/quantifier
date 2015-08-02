require "spec_helper"

describe "Home page" do
  scenario "anonymous user logs in to the app" do
    visit root_path
    expect(page).to have_content("Welcome")
    expect(page).to have_content("Please sign in")

    set_mock_auth
    click_link "Sign in"
    expect(page.current_path).to eq('/providers')
    expect(@page).not_to have_content("Please sign in")
    expect(page).to have_content("Get new scores")
    click_link "Get new scores"
    expect(page).to have_content("Scores updated")
    expect(page.current_path).to eq(providers_path)
  end
end
