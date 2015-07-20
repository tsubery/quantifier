require "spec_helper"

describe "Typeracer goals" do
  scenario "create first goal" do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    mock_typeracer_validation
    visit providers_path

    page.click_link("Setup typeracer goal")

    page.fill_in "provider_uid", with: "typeracer_uid"
    page.fill_in "provider_uid", with: "typeracer_uid"
    page.select "slug2", from: "provider_goal_slug"
    page.click_button "Save"

    expect(page).to have_content("Updated successfully!")

    provider = user.providers.first
    expect(provider).not_to be_nil
    goal = provider.goal
    expect(goal).to be_persisted
    expect(goal.slug).to eq("slug2")
  end
end
