require "spec_helper"

describe "Pocket goals" do
  scenario "create first goal" do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    visit providers_path
    expect(page).to have_content "Connect pocket"

    mock_auth :pocket
    page.click_link("Connect pocket")
    expect(page).to have_content "Setup pocket"

    mock_provider_score :pocket
    page.click_link("Setup pocket")

    page.select "slug2", from: "provider_goal_attributes_slug"
    page.click_button "Save"

    expect(page).to have_content("Updated successfully!")
    expect(page).to have_content("slug2")
    expect(page).to have_content("Connected as mock_uid")

    page.click_link("Setup pocket")
    expect(page).to have_select("provider_goal_attributes_slug", selected: "slug2")

    provider = user.providers.first
    expect(provider).not_to be_nil
    goal = provider.goal
    expect(goal).to be_persisted
    expect(goal.slug).to eq("slug2")

    visit providers_path
    page.click_link("Disconnect")
    expect(page).to have_content("Deleted pocket")
    expect(user.providers.reload).to be_empty
  end
end
