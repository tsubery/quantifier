module Repo
  def find(key)
    collection[key.to_sym]
  end

  def find!(key)
    known_key = key.respond_to?(:to_sym) && collection.key?(key.to_sym)
    raise "Unknown key #{key}" unless known_key
    find(key)
  end

  def store(key, object)
    return nil if key.nil?
    collection[key.to_sym] = object
  end

  delegate :keys, to: :collection

  private

  def collection
    @collection ||= {}
  end
end
