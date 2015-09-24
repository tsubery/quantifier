class GoalDecorator < Draper::Decorator
  delegate_all

  def status
    "active"
  end

  def last_score
    score = scores.last
    score.nil? ? "none" : score.value
  end

  def beeminder_link(beeminder_user_id)
    h.link_to slug, "https://www.beeminder.com/#{beeminder_user_id}/goals/#{slug}"
  end

  def delete_link
    h.link_to "Delete",
      h.goal_path(self),
      method: :delete,
      "data-confirm": "Are you sure?"
  end

end
