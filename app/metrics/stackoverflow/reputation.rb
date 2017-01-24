PROVIDERS.fetch(:stackoverflow).register_metric :reputation do |metric|
  metric.title = "Reputation"
  metric.description = "Reputation score"

  metric.block = proc do |adapter|
    Datapoint.new value: adapter.reputation
  end
end
