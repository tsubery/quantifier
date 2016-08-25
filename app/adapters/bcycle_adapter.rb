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

  def statistics_for_last(duration: 3.days)
    now = UTC.now
    # to cover all timezones we use wider range
    # we err on making too many requests than missing some
    start_ts = now - 4.days
    end_ts = now + 1.day
    trips = statistics_for(end_ts)
    if end_ts.month != start_ts.month
      trips.merge! statistics_for(start_ts)
    end

    cutoff = now - duration
    trips.select do |ts, _|
      ts > cutoff
    end.to_h
  end

  private

  def statistics_for(time)
    client.statistics_for(time)
  rescue MyBcycle::InvalidCredentials
    raise AuthorizationError
  end

  def uid
    credentials.fetch :uid
  end

  def password
    credentials.fetch :password
  end
end
