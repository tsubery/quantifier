PROVIDERS.fetch(:googlefit).register_metric :strength_training do |metric|
  metric.title = "Strength training"
  metric.description = "Minutes of strength training"

  metric.block = proc do |adapter|
    points = adapter.fetch_strength

    points.each_with_object(Hash.new { 0 }) do |point, scores|
      ts_start = point.start_time_nanos.to_i / 1e9
      ts_end = point.end_time_nanos.to_i / 1e9
      hour = Time.zone.at(ts_start).beginning_of_hour
      scores[hour] += ((ts_end - ts_start) / 60.0).ceil
    end.map do |ts, value|
      Datapoint.new(unique: true, timestamp: ts, value: value)
    end
  end
end
