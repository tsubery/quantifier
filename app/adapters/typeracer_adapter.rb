require_relative 'base_adapter'
class TyperacerAdapter < BaseAdapter

  def self.required_keys
    %i(uid)
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
