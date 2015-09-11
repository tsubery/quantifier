Pocket.configure do |config|
  config.consumer_key = Rails.application.secrets.pocket_provider_key
end
Provider.register :pocket, auth_type: :oauth, adapter: PocketAdapter
