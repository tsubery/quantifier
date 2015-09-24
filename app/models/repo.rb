module Repo
  def find key
    key = key.to_sym
    raise "Unknown key #{key}" unless collection.has_key?(key)
    collection[key]
  end

  def store key, object
    key = key.to_sym
    collection[key] = object
  end

  def keys
    collection.keys
  end

  private
  def collection
    @collection ||= {}
  end
end
