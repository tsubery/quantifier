ProviderRepo.find!(:googlefit).register_metric :strength_training do |metric|
  metric.title = "Strength training"
  metric.description = "Minutes of strength training"

  metric.block = proc do |adapter|
    points = adapter.fetch_strength

    points.each_with_object(Hash.new { 0 }) do |point, scores|
      ts_epoch = point.start_time_nanos.to_i / 1_000_000_000
      hour = Time.zone.at(ts_epoch).beginning_of_hour
      scores[hour] += point.value.first.int_val / 1.minute
    end.map do |ts, value|
      Datapoint.new unique: true, timestamp: ts, value: value
    end
  end
end
