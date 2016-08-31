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
    cutoff = now - duration

    trips = relevant_months.map(&method(:statistics_for)).reduce(:merge)
    trips.select { |ts, _| ts > cutoff }.to_h
  end

  private

  def relevant_months
    # to cover all timezones we use wider range
    # we err on making too many requests than missing some
    start_ts = now - 4.days
    end_ts = now + 1.day
    if end_ts.month != start_ts.month
      [start_ts, end_ts]
    else
      [start_ts]
    end
  end

  def now
    @now ||= UTC.now
  end

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
