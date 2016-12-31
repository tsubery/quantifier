PROVIDERS.fetch(:googlefit).register_metric :sleep_duration_hours do |metric|
  metric.title = "Sleep Duration"
  metric.description = "Hours of sleep"

  metric.block = proc do |adapter, params|
    tz = ActiveSupport::TimeZone.new(params["timezone"].to_s)

    if tz.nil?
      OpenStruct.new(value: "Please configure timezone and reload page")
    else
      # We want to catch the window of possible sleeps
      retro_window_start = tz.now.beginning_of_day - 2.days - 12.hours
      points = adapter.filter_segments(retro_window_start) do |activity_id|
        GooglefitAdapter::SLEEP_SEGMENT_CODE == activity_id
      end
      points.each_with_object({}) do |point, scores|
        start_ts = point.start_time_nanos.to_i / 1_000_000_000
        end_ts = point.end_time_nanos.to_i / 1_000_000_000

        day = (tz.at(start_ts) - 6.hours).beginning_of_day

        scores[day] ||=0
        scores[day] += (end_ts.to_f - start_ts.to_f) / 3_600
      end.map do |ts, value|
        Datapoint.new(unique: true, timestamp: ts, value: value)
      end
    end
  end

  metric.configuration = proc do |_client, params|
    tz = params["timezone"]

    [
      [:timezone, select_tag("goal[params][timezone]",
                             time_zone_options_for_select(selected: tz),
                             class: "form-control")],
    ]
  end
end
