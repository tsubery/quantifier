PROVIDERS.fetch(:googlefit).register_metric :bed_time_lag_minutes do |metric|
  metric.title = "Bed time lag"
  metric.description = "Minutes after defined bedtime"

  metric.block = proc do |adapter, params|
    tz = ActiveSupport::TimeZone.new(params["timezone"].to_s)
    bed_time_hour = params["bed_time_hour"].to_i
    bed_time_minute = params["bed_time_minute"].to_i

    if bed_time_hour.nil? || bed_time_minute.nil? || tz.nil?
      OpenStruct.new(value: "Please configure timezone and reload page")
    else
      defined_bed_time_minutes = 60 * bed_time_hour + bed_time_minute

      # We want to catch the window of possible sleeps
      todays_bed_time = tz.now.beginning_of_day + defined_bed_time_minutes.minutes
      todays_bed_time_window_start = todays_bed_time - 12.hours
      retro_window_start = todays_bed_time_window_start - 2.days
      points = adapter.fetch_sleeps(retro_window_start)

      points.each_with_object({}) do |point, scores|
        ts_epoch = point.start_time_nanos.to_i / 1_000_000_000
        half_day_minutes = 60 * 12

        bed_time = tz.at(ts_epoch)
        actual_bed_time_minutes = 60 * bed_time.hour + bed_time.min
        diff = (actual_bed_time_minutes - defined_bed_time_minutes)
        remainder = (diff + half_day_minutes) % (24 * 60)
        value = [0, remainder - half_day_minutes].max

        day = (bed_time - 12.hours).beginning_of_day
        scores[day] = [value, scores[day]].compact.min
      end.map do |ts, value|
        Datapoint.new(unique: true, timestamp: ts, value: value)
      end
    end
  end

  metric.configuration = proc do |_client, params|
    tz = params["timezone"]
    bed_time_hour = params["bed_time_hour"]
    bed_time_minute = params["bed_time_minute"]
    hour_options = (1..24).to_a
    minute_options = (0..59).to_a

    [
      [:hour, select_tag("goal[params][bed_time_hour]",
                         options_for_select(hour_options,
                                            selected: bed_time_hour),
                         class: "form-control")],
      [:minute, select_tag("goal[params][bed_time_minute]",
                           options_for_select(minute_options,
                                              selected: bed_time_minute),
                           class: "form-control")],
      [:timezone, select_tag("goal[params][timezone]",
                             time_zone_options_for_select(selected: tz),
                             class: "form-control")],
    ]
  end
end
