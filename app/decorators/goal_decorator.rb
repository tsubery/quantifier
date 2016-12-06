class GoalDecorator < DelegateClass(Goal)
  include ActionView::Helpers::UrlHelper
  # nclude ActionView::Helpers::AssetTagHelper

  def status
    active ? "Enabled" : "Disabled"
  end

  def last_score
    score = scores.order(:timestamp).last
    score.nil? ? "none" : score.value
  end

  def beeminder_link(beeminder_user_id)
    link_to slug, "https://www.beeminder.com/#{beeminder_user_id}/goals/#{slug}"
  end

  def delete_link
    link_to "Delete",
            routes.goal_path(self),
            method: :delete,
            "data-confirm": "Are you sure?",
            class: %i(btn btn-default)
  end

  def safe_fetch_scores
    fetch_scores
  rescue => e
    Rails.logger.error e.inspect
    msg = "Could not fetch scores."
    if e.is_a? BaseAdapter::AuthorizationError
      msg += " Please authorize again"
    end
    [OpenStruct.new(timestamp: "now", value: msg)]
  end

  def metric_link
    title = [provider.title, metric.title].join(" - ")
    link_to title,
            ProviderDecorator.new(provider).metric_path(metric),
            title: "Click to configure"
  end

  private

  def routes
    Rails.application.routes.url_helpers
  end
end
