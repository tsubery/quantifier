class LastfmAdapter < BaseAdapter
  class << self
    def required_keys
      %i(username api_key)
    end

    def auth_type
      :none
    end

    def website_link
      "https://www.last.fm"
    end

    def title
      "Last.fm"
    end

    def valid_credentials?(credentials)
      username, api_key = credentials.values_at(:username, :api_key)
      username.present? && api_key.present?
    end
  end

  def scrobbles
    username, api_key = credentials.values_at(:username, :api_key)
    resp = Faraday.get("http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=#{username}&api_key=#{api_key}&format=json")

    user_info = JSON.parse(resp.body)
    if user_info
      user_info.fetch("user.playcount").to_i
    else
      raise "Can't fetch user playcount"
    end
  end

end
