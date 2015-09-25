module Repo
  def find key
    collection[key.to_sym]
  end

  def find! key
    raise "Unknown key #{key}" unless key.respond_to?(:to_sym) && collection.has_key?(key.to_sym)
    find(key)
  end

  def store key, object
    return nil if key.nil?
    collection[key.to_sym] = object
  end

  def keys
    collection.keys
  end

  private
  def collection
    @collection ||= {}
  end
end
