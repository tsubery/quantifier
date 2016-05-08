PROVIDERS.fetch(:typeracer).register_metric :completed_games do |metric|
  metric.title = "Completed Games"
  metric.description = "Number of completed games"

  metric.block = proc do |adapter|
    Datapoint.new value: adapter.completed_games
  end
end
