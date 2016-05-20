PROVIDERS.fetch(:trello).register_metric :idle_hours_average do |metric|
  metric.description = "Average time each card has been idle measured in hours"
  metric.title = "Card average age"

  metric.block = proc do |adapter, options|
    now_utc = Time.current.utc
    list_ids = Array(options[:list_ids])
    cards = adapter.cards(list_ids)

    sum = cards.map do |card|
      (now_utc - card.last_activity_date) / 1.hour
    end.sum
    value = sum.zero? ? sum : sum / cards.count

    Datapoint.new value: value.to_i
  end

  metric.configuration = proc do |client, params|
    list_ids = Array(params["list_ids"])
    [
      [:list_ids, select_tag("goal[params][list_ids]",
                             options_for_select(client.list_options,
                                                selected: list_ids),
                             multiple: true,
                             class: "form-control")],
    ]
  end
end
