PROVIDERS.fetch(:bcycle).register_metric :trip_length do |metric|
  metric.title = "Trip length"
  metric.description = "Length of trips in miles"

  metric.block = proc do |adapter|
    adapter.statistics_for_lastmap do |ts, data|
      Datapoint.new(
        unique: true,
        timestamp: ts,
        value: data.fetch(:miles)
      )
    end
  end
end
