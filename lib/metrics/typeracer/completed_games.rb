ProviderRepo.find!(:typeracer).register_metric :completed_games do |metric|
    metric.title = "Completed Games"
    metric.description = "Number of completed games"

    metric.block = Proc.new do |adapter|
        Datapoint.new timestamp: Time.current.utc,
            value: adapter.completed_games
    end
end
