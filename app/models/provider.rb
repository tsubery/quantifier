class Provider
  attr_reader :auth_type, :adapter, :key
  delegate :find, :metrics, to: :metrics_repo
  delegate :auth_type, :title, :website_link, to: :adapter
  alias find_metric find
  alias name key

  def initialize(key, adapter)
    @adapter = adapter
    @key = key
    @metrics_repo = MetricRepo.new
    %i(none oauth password).include?(auth_type) || raise("Unknown auth_type #{auth_type}")
  end

  def oauth?
    :oauth == auth_type
  end

  def public?
    :none == auth_type
  end

  def password_auth?
    :password == auth_type
  end

  def register_metric(key)
    new_metric = Metric.new(key)
    yield new_metric
    raise "Invalid metric #{key}" unless new_metric.valid?
    metrics_repo.store key, new_metric
  end

  def load_metrics
    Dir["app/metrics/#{key}/*.rb"].each { |f| load Rails.root.join(f) }
  end

  private

  attr_reader :metrics_repo
end
