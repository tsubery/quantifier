PROVIDERS.fetch(:trello).register_metric :idle_days_linear do |metric|
  metric.description = "Sum of days each card has been idle"
  metric.title = "Cards backlog"

  metric.block = proc do |adapter, options|
    now_utc = Time.current.utc
    list_ids = Array(options[:list_ids])
    cards = adapter.cards(list_ids)
    value = cards.map do |card|
      now_utc - card.last_activity_date
    end.sum / 1.day

    Datapoint.new(value: value.to_i)
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
