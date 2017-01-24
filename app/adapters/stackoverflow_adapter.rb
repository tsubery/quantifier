class StackoverflowAdapter < BaseAdapter
  class << self
    def required_keys
      %i(uid)
    end

    def auth_type
      :none
    end

    def website_link
      "http://www.stackoverflow.com"
    end

    def title
      "StackOverflow"
    end

    def valid_credentials?(credentials)
      uid = credentials["uid"]
      uid.to_i > 0 && uid.to_i.to_s == uid
    end
  end

  def reputation
    uid = credentials.fetch(:uid)
    resp = Faraday.get("https://api.stackexchange.com/2.2/users/#{uid.to_i}?site=stackoverflow")

    user_info = JSON.parse(resp.body)["items"]&.first
    if user_info
      user_info.fetch("reputation")
    else
      raise "Can't fetch reputation"
    end
  end

end
