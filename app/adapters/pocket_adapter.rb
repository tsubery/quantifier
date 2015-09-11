require_relative 'base_adapter'
class PocketAdapter < BaseAdapter

  def self.required_keys
    %i(token)
  end

  def client
    Pocket.client access_token: access_token
  end

  def articles
    articles = list("article" )
    return [] if articles.empty?
    articles.respond_to?(:values) ? articles.values : []
  end

  def list content_type
    client.retrieve(contentType: contentType).fetch("list")
  end

  def access_token
    credentials.fetch :token
  end
end
