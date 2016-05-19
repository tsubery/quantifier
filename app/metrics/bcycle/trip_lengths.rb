PROVIDERS.fetch(:bcycle).register_metric :trip_length do |metric|
  metric.title = "Trip length"
  metric.description = "Length of trips in miles"

  metric.block = proc do |adapter|
    now = UTC.now
    trips = [
      # to cover all timezones we use wider range
      # we err on making too many requests than missing some
      now + 1.day,
      now - 4.days
    ].flat_map do |ts|
      adapter.statistics_for(ts).to_a
    end.to_h

    cutoff = now - 3.days

    trips.select do |ts,_|
      ts > cutoff
    end.map do |ts, data|
      Datapoint.new(
        unique: true,
        timestamp: ts,
        value: data.fetch(:miles)
      )
    end
  end
end
