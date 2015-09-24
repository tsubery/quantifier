require 'base_adapter'
class PocketAdapter < BaseAdapter

  def initialize *args
    Pocket.configure do |config|
      config.consumer_key = Rails.application.secrets.pocket_provider_key
    end
    super
  end

  class << self
    def required_keys
      %i(token)
    end

    def auth_type
      :oauth
    end

    def website_link
      "https://getpocket.com"
    end

    def title
      "Pocket"
    end
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
    client.retrieve(contentType: content_type).fetch("list")
  end

  def access_token
    credentials.fetch :token
  end
end
