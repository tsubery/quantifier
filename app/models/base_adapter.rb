class BaseAdapter
  InvalidCredentials = Class.new(StandardError)

  def initialize credentials
    @credentials = credentials.with_indifferent_access
    validate_credentials!
  end

  def self.load_all
    Dir["lib/adapters/*_adapter.rb"].each do |file|
      require Rails.root.join(file)
      key = file[%r{\Alib/adapters\/([^_]+)_adapter.rb\z},1]
      adapter = "#{key}_adapter".camelize.constantize
      provider = Provider.new key, adapter
      ProviderRepo.store key, provider
      provider.load_metrics
    end
  end

  private

  attr_reader :credentials
  def required_keys
    raise NotImplementedError
  end

  def validate_credentials!
    unless self.class.valid_credentials?(credentials)
      raise(InvalidCredentials, credentials.to_s)
    end
  end

  def self.valid_credentials?(credentials)
    credentials.values_at(*required_keys).all? &:present?
  end

  def access_token
    credentials.fetch :token
  end

  def access_secret
    credentials.fetch :secret
  end

  def uid
    credentials.fetch :uid
  end
end

