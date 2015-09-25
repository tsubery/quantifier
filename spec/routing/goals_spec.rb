require "rails_helper"

describe "Goal routes" do
  %w(
    /goals/googlefit/hourly_steps
    /goals/pocket/article_days_linear
    /goals/trello/idle_days_linear
    /goals/typeracer/completed_games
  ).each do |known_path|
    it "has route to create #{known_path}" do
      expect(get: known_path).to be_routable
    end
  end

  %w(
    /goals/asdf/unknown
    /goals/googlefit/asdf
    /goals/asdff
  ).each do |unknown_path|
    it "doesn't have route for unknown path #{unknown_path}" do
      expect(get: unknown_path).not_to be_routable
    end
  end
end
