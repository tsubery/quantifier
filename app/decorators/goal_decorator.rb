class GoalDecorator < Draper::Decorator
  delegate_all

  def status
    active ? "Enabled" : "Disabled"
  end

  def last_score
    score = scores.order(:timestamp).last
    score.nil? ? "none" : score.value
  end

  def beeminder_link(beeminder_user_id)
    h.link_to slug, "https://www.beeminder.com/#{beeminder_user_id}/goals/#{slug}"
  end

  def delete_link
    h.link_to "Delete",
              h.goal_path(self),
              method: :delete,
              "data-confirm": "Are you sure?",
              class: %i(btn btn-default)
  end

  def safe_fetch_scores
    object.fetch_scores
  rescue => e
    Rails.logger.error e.inspect
    msg = "Could not fetch scores."
    if e.is_a? BaseAdapter::AuthorizationError
      msg += " Please authorize again"
    end
    [OpenStruct.new(timestamp: "now", value: msg)]
  end

  def metric_link
    title = [goal.provider.title, goal.metric.title].join(" - ")
    h.link_to title,
              ProviderDecorator.new(goal.provider).metric_path(metric),
              title: "Click to configure"
  end
end
