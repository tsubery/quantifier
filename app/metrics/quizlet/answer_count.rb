PROVIDERS.fetch(:quizlet).register_metric :answers do |metric|
  metric.title = "Answer count"
  metric.description = "Number of answered questions"

  metric.block = proc do |adapter|
    Datapoint.new(value: adapter.answer_count)
  end
end
