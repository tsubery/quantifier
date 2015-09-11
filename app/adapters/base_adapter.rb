require 'active_support/all'
class BaseAdapter
  InvalidCredentials = Class.new(StandardError)

  def initialize credentials
    @credentials = credentials.with_indifferent_access
    validate_credentials!
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

end
