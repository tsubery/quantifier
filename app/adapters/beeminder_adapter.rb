class BeeminderAdapter < BaseAdapter
  RECENT_INTERVAL = 2.days.ago
  MAX_SLUG_LENGNTH = 250

  class << self
    def required_keys
      %i(token)
    end

    def auth_type
      :oauth
    end

    def website_link
      "https://www.beeminder.com"
    end

    def title
      "Beeminder"
    end
  end

  def client
    @client ||= Beeminder::User.new access_token, auth_type: :oauth
  end

  def goals
    @goals ||= client.goals
  end

  def recent_datapoints(slug)
    goal = goals.find { |g| g.slug == slug }
    return [] unless goal
    goal.datapoints.select do |dp|
      dp.timestamp > RECENT_INTERVAL
    end
  rescue
    Rails.logger.error("Failed to fetch datapoints for slug #{slug} of goal #{goal.inspect}")
    raise
  end
end
