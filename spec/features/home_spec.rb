require "rails_helper"

describe "Home page" do
  scenario "anonymous user logs in to the app" do
    visit root_path
    expect(page).to have_content("Welcome")
    expect(page).to have_content("sign in")
  end

  scenario "User signs in " do
    visit root_path
    mock_auth
    click_link "Sign in"
    expect(page.current_path).to eq(root_path)
    expect(@page).not_to have_content("Please sign in")
    expect(@page).not_to have_content("Welcome")
  end
  context "signed in user" do
    scenario "without goals" do
      user = create(:user)
      mock_current_user user
      visit root_path
      expect(page).not_to have_content("Reload")
      expect(page).to have_content("Welcome")
    end
    scenario "that has goals" do
      goal = create :goal
      mock_current_user goal.user
      visit root_path
      expect(page).to have_content("Reload")
      fake_worker = double(BeeminderWorker)
      expect(BeeminderWorker).to receive(:new).and_return(fake_worker)
      expect(fake_worker).to(
        receive(:perform).with(beeminder_user_id: goal.user.beeminder_user_id)
      )
      click_link "Reload"
      expect(page).to have_content("Scores updated")
      expect(page.current_path).to eq(root_path)
    end
  end
end
