require 'spec_helper'

describe "Pocket goals" do
  scenario 'create first goal' do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    visit providers_path
    expect(page).to have_content 'Connect your pocket account'

    set_mock_auth :pocket
    page.click_link('Connect your pocket account')
    expect(page).to have_content 'Setup pocket goal'

    mock_provider_score :pocket
    page.click_link("Setup pocket goal")

    page.select "slug2", from: "provider_goal_attributes_slug"
    page.click_button "Save"

    expect(page).to have_content("Updated successfully!")

    page.click_link("Setup pocket goal")
    expect(page).to have_select("provider_goal_attributes_slug", selected: "slug2")

    provider = user.providers.first
    expect(provider).not_to be_nil
    goal = provider.goal
    expect(goal).to be_persisted
    expect(goal.slug).to eq("slug2")

  end
end
