require_relative 'base_adapter'
class TrelloAdapter < BaseAdapter

  def self.required_keys
    %i(token secret)
  end

  def client
    Trello::Client.new(
      consumer_key: Rails.application.secrets.trello_provider_key,
      consumer_secret: Rails.application.secrets.trello_provider_key,
      oauth_token: access_token,
      oauth_token_secret: access_secret
    )
  end

  def cards(list_ids)
    list_ids.flat_map do |list_id|
      client.find(:list, list_id).cards.map(&:itself)
    end
  end

  def list_options
    client.find(:member, uid).boards(filter: :open).flat_map do |b|
      b.lists.map do |list|
        joined_name = [b.name, l.name].join("/")
        [joined_name, list.id]
      end
    end
  end
end
