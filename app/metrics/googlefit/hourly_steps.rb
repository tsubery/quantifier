PROVIDERS.fetch(:googlefit).register_metric :hourly_steps do |metric|
  metric.title = "Hourly Steps"
  metric.description = "Steps taken each hour"

  metric.block = proc do |adapter|
    points = adapter.fetch_steps

    points.each_with_object(Hash.new { 0 }) do |point, scores|
      ts_epoch = point.start_time_nanos.to_i / 1_000_000_000
      hour = Time.zone.at(ts_epoch).beginning_of_hour
      scores[hour] += point.value.first.int_val
    end.map do |ts, value|
      Datapoint.new(unique: true, timestamp: ts, value: value)
    end
  end
end
