require "rails_helper"

describe "Googlefit goals" do
  scenario "create hourly steps goal" do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    mock_auth :googlefit
    mock_provider_score
    visit root_path

    expect(user.credentials).to be_empty
    expect(user.goals).to be_empty

    page.click_link("Hourly Steps")
    expect(user.credentials.count).to eq(1)
    expect(user.credentials.first.provider_name).to eq("googlefit")
    expect(page.current_path).to eq(root_path)

    page.click_link("Hourly Steps")
    expect(page).to have_content "Google Fit Hourly Steps"
    expect(page).to have_content "Goal Configuration"

    page.select "slug2", from: "goal_slug"
    page.click_button "Save"
    expect(page).to have_content("Updated successfully!")
    expect(user.goals.count).to eq(1)
    goal = user.goals.first
    expect(goal.metric_key).to eq("hourly_steps")
    expect(goal.slug).to eq("slug2")
    expect(page).to have_css("#configured-goals", text: "Google Fit - Hourly Steps")

    page.click_link("Hourly Steps")
    expect(page).to have_select("goal_slug", selected: "slug2")
    click_link "Delete"
    expect(page).to have_content("Deleted successfully!")
    expect(user.reload.goals).to be_empty
  end
end
