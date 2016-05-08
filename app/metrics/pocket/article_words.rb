PROVIDERS.fetch(:pocket).register_metric :article_words do |metric|
  metric.description = "The sum of words in all articles"
  metric.title = "Total word count"

  metric.block = proc do |adapter|
    value = adapter.articles.map do |article|
      article["word_count"].to_i
    end.sum

    Datapoint.new(value: value)
  end
end
