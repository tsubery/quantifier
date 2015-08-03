require "spec_helper"

describe "Trello goals" do
  scenario "create first goal" do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    visit providers_path
    expect(page).to have_content "Connect trello"

    mock_auth :trello
    page.click_link("Connect trello")
    expect(page).to have_content "Setup trello"

    mock_provider_score :trello
    mock_trello_boards

    page.click_link("Setup trello")

    page.select "slug2", from: "provider_goal_attributes_slug"
    page.select "List2", from: "provider_goal_attributes_params_list_ids"
    page.select "List3", from: "provider_goal_attributes_params_list_ids"
    page.click_button "Save"

    expect(page).to have_content("Updated successfully!")

    page.click_link("Setup trello")
    expect(page).to have_select("provider_goal_attributes_slug", selected: "slug2")
    expect(page).to have_select "provider_goal_attributes_params_list_ids",
                                selected: %w(List2 List3)

    provider = user.providers.first
    expect(provider).not_to be_nil
    goal = provider.goal
    expect(goal).to be_persisted
    expect(goal.slug).to eq("slug2")
    expect(provider.list_ids).to eq(%w(2 3))

    visit providers_path
    page.click_link("Disconnect")
    expect(page).to have_content("Deleted trello")
    expect(user.providers.reload).to be_empty
  end
end
