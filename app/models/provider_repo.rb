class ProviderRepo
  extend Repo

  class << self
    alias_method :names, :keys
  end
end
BaseAdapter.load_all
