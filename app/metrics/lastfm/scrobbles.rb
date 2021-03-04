PROVIDERS.fetch(:lastfm).register_metric :scrobbles do |metric|
  metric.title = "Scrobbles"
  metric.description = "Number of scrobbles"

  metric.block = proc do |adapter|
    Datapoint.new value: adapter.scrobbles
  end
end
