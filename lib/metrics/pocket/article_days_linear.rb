ProviderRepo.find!(:pocket).register_metric :article_days_linear do |metric|
  metric.description = "The sum of days since each article has been added"
  metric.title = "Article backlog"

  metric.block = Proc.new do |adapter|
    now_as_epoch = Time.current.utc.to_i
    value = adapter.articles.map do |article|
      now_as_epoch - article["time_added"].to_i
    end.sum / 1.day.to_i

    Datapoint.new timestamp: Time.current.utc,
      value: value
  end
end
