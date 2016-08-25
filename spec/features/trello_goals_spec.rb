require "rails_helper"

describe "Trello goals" do
  scenario "create cards backlog goal" do
    user = create(:user)
    mock_current_user user
    mock_beeminder_goals(user, %w(slug1 slug2 slug3))
    mock_auth :trello
    mock_provider_score
    visit root_path

    expect(user.credentials).to be_empty
    expect(user.goals).to be_empty

    page.click_link("Cards backlog")
    expect(user.credentials.count).to eq(1)
    expect(user.credentials.first.provider_name).to eq("trello")
    expect(page.current_path).to eq(root_path)

    mock_trello_boards
    page.click_link("Cards backlog")
    expect(page).to have_content "Trello Cards backlog"
    expect(page).to have_content "Goal Configuration"

    page.select "slug2", from: "goal_slug"
    page.select "List2", from: "goal_params_list_ids"
    page.select "List3", from: "goal_params_list_ids"
    page.click_button "Save"
    expect(page).to have_content("Updated successfully!")
    goal = user.goals.first
    expect(goal.metric_key).to eq("idle_days_linear")
    expect(goal.slug).to eq("slug2")
    expect(page).to have_css("#configured-goals", text: "Trello - Cards backlog")

    page.click_link("Cards backlog")
    expect(page).to have_select("goal_slug", selected: "slug2")
    expect(page).to have_select "goal_params_list_ids",
                                selected: %w(List2 List3)

    click_link "Delete"
    expect(page).to have_content("Deleted successfully!")
    expect(user.reload.goals).to be_empty
  end
end
