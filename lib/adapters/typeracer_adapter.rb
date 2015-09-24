require 'base_adapter'
class TyperacerAdapter < BaseAdapter

  class << self
    def required_keys
      %i(uid)
    end

    def auth_type
      :none
    end

    def website_link
      "http://typeracer.com"
    end

    def title
      "Typeracer"
    end
  end

  def client
    TypeRacer::Client.new(uid)
  end

  def completed_games
    client.completed_games
  end

  def self.valid_credentials?(credentials)
    !!TypeRacer::Client.new(credentials.fetch(:uid))
  rescue TypeRacer::Api::UserNotFound,  KeyError
    false
  end

  def uid
    credentials.fetch :uid
  end

end
