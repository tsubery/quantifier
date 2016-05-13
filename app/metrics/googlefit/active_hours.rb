PROVIDERS.fetch(:googlefit).register_metric :active_hours do |metric|
  metric.title = "Active time"
  metric.description = "Hours of physical activity"

  metric.block = proc do |adapter|
    points = adapter.fetch_active

    points.each_with_object(Hash.new { 0 }) do |point, scores|
      ts_start = point.start_time_nanos.to_i / 1e9
      ts_end = point.end_time_nanos.to_i / 1e9
      hour = Time.zone.at(ts_start).beginning_of_hour
      scores[hour] += (ts_end - ts_start) / 3600.0
    end.map do |ts, value|
      Datapoint.new(unique: true, timestamp: ts, value: value)
    end.sort_by(&:timestamp)
  end
end
