PROVIDERS.fetch(:beeminder).register_metric :count_datapoints do |metric|
  metric.description =
    "Sends the hourly count of datapoints from selected goals to the target goal"
  metric.title = "Count Datapoints"
  slug_key = "source_slugs"

  metric.block = proc do |adapter, options|
    Array(options[slug_key]).flat_map do |slug, factor|
      next [] if factor.blank?
      adapter.recent_datapoints(slug).map do |dp|
        value = dp.value * Float(factor)
        [
          dp.timestamp.utc,
          value,
          "#{slug}: #{value.round(2)}",
        ]
      end
    end.group_by(&:first).map do |ts, entries|
      Datapoint.new(
        unique: true,
        timestamp: ts,
        value: entries.map(&:second).reject(&:zero?).count,
        comment_prefix: entries.map(&:third).join(",")
      )
    end
  end

  metric.param_errors = proc do |params|
    slugs = params[slug_key]
    if slugs.is_a?(Hash)
      errors = []

      valid_factors = slugs.values.reject(&:blank?).all? do |factor|
        begin
          Float(factor)
        rescue ArgumentError
          false
        end
      end
      valid_slugs = slugs.keys.all? do |key|
        key.is_a?(String) && key.length < 20
      end

      errors << "All factors must be numbers" unless valid_factors

      errors << "Invalid slug" unless valid_slugs

      errors
    else
      ["Must provide #{slug_key} hash"]
    end
  end
end
