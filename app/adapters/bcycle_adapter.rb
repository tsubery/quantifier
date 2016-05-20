class BcycleAdapter < BaseAdapter
  class << self
    def required_keys
      %i(username password)
    end

    def auth_type
      :password
    end

    def website_link
      "https://austin.bcycle.com"
    end

    def title
      "Austin Bcycle"
    end
  end

  def client
    @client ||= self.class.client(uid, password)
  end

  delegate :completed_games, to: :client

  def self.valid_credentials?(credentials)
    username, password = credentials.values_at(:uid, :password)
    username.present? && password.present?
  end

  def self.client(username, password)
    MyBcycle::User.new(
      username: username,
      password: password
    )
  end

  def uid
    credentials.fetch :uid
  end

  def password
    credentials.fetch :password
  end

  def statistics_for(time)
    client.statistics_for(time)
  rescue MyBcycle::InvalidCredentials
    raise AuthorizationError
  end
end
