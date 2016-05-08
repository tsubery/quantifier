class BeeminderAdapter < BaseAdapter
  class << self
    def required_keys
      %i(token)
    end

    def auth_type
      :oauth
    end

    def website_link
      "https:/www.beeminder.com"
    end

    def title
      "Beeminder"
    end
  end

  def client
    Beeminder::User.new access_token, auth_type: :oauth
  end

  delegate :goals, to: :client
end
