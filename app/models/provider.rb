class Provider
  attr_reader :auth_type, :adapter, :key

  def initialize key, auth_type, adapter
    [:none, :oauth].include?(auth_type) or raise "Unknown auth_type #{auth_type}"
    @auth_type = auth_type
    @adapter = adapter
    @key = key
  end

  def oauth?
    :oauth == auth_type
  end

  def public?
    :none == auth_type
  end

  def register_metric key
    new_metric = Metric.new(key)
    metrics[key] = new_metric
    yield new_metric
    raise "Invalid metric #{key}" unless new_metric.valid?
  end

  def find_metric key
    metrics[key] or raise "Unknown metric #{key}"
  end

  def metric_keys
    metrics.keys
  end

  def load_metrics
    Dir["lib/metrics/#{key}/*.rb"].each { |f| require Rails.root.join(f) }
  end

  private

  def metrics
    @metrics ||= {}.with_indifferent_access
  end

  class << self

    def register name, adapter: , auth_type:
      providers[name] = new(name, auth_type, adapter)
      providers[name].load_metrics
    end

    def find name
      providers[name] or raise "Unknown provider #{name}"
    end

    def names
      providers.keys
    end
    private

    def providers
      @providers ||= {}.with_indifferent_access
    end
  end

end
