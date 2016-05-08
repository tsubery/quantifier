PROVIDERS = %i(
    beeminder googlefit pocket quizlet trello typeracer
).map do |p_key|
    adapter = "#{p_key}_adapter".camelize.constantize
    [p_key, Provider.new(p_key, adapter)]
end.to_h.with_indifferent_access
PROVIDERS.values.each(&:load_metrics)
