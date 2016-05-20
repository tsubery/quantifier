PROVIDERS.fetch(:bcycle).register_metric :trip_durations do |metric|
  metric.title = "Trip duration"
  metric.description = "Duration of trips in minutes"

  metric.block = proc do |adapter|
    adapter.statistics_for_last.map do |ts, data|
      Datapoint.new(
        unique: true,
        timestamp: ts,
        value: data.fetch(:duration)
      )
    end
  end
end
