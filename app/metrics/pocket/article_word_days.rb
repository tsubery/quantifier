PROVIDERS.fetch(:pocket).register_metric :article_word_days do |metric|
  metric.description = "The sum of days since each word in an article has been added"
  metric.title = "Article words backlog"

  metric.block = proc do |adapter|
    now_as_epoch = Time.current.utc.to_i
    value = adapter.articles.map do |article|
      age = (now_as_epoch - article["time_added"].to_i) / 1.day.to_i
      age * article["word_count"].to_i
    end.sum

    Datapoint.new(value: value)
  end
end
