class ProviderRepo
  extend Repo

  class << self
    alias names keys
  end
end
BaseAdapter.load_all
