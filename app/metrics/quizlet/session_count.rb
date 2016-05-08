PROVIDERS.fetch(:quizlet).register_metric :study_sessions do |metric|
  metric.title = "Study sessions"
  metric.description = "Number of study sessions"

  metric.block = proc do |adapter|
    Datapoint.new(value: adapter.session_count)
  end
end
