class MetricRepo
  include Repo

  def metrics
    collection.values
  end
end
