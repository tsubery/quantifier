require "spec_helper"

describe "Trello goals" do
  scenario "create first goal" do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    visit providers_path
    expect(page).to have_content "Connect trello"

    set_mock_auth :trello
    page.click_link("Connect trello")
    expect(page).to have_content "Setup trello"

    mock_provider_score :trello
    mock_trello_boards

    page.click_link("Setup trello")

    page.select "slug2", from: "provider_goal_attributes_slug"
    page.select "Board3", from: "provider_goal_attributes_params_board_id"
    page.click_button "Save"

    expect(page).to have_content("Updated successfully!")

    page.click_link("Setup trello")
    expect(page).to have_select("provider_goal_attributes_slug", selected: "slug2")
    expect(page).to have_select("provider_goal_attributes_params_board_id", selected: "Board3")

    provider = user.providers.first
    expect(provider).not_to be_nil
    goal = provider.goal
    expect(goal).to be_persisted
    expect(goal.slug).to eq("slug2")
    expect(provider.board_id).to eq("3")
  end
end
