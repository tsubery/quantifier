PROVIDERS.fetch(:trello).register_metric :idle_days_exponential do |metric|
  metric.description = "Sum the days each card has been idle raised to the chosen power"
  metric.title = "Cards backlog Exp"

  metric.block = proc do |adapter, options|
    exponent = (options["exponent"] || 2.0).to_f
    now_utc = Time.current.utc
    list_ids = Array(options["list_ids"])
    cards = adapter.cards(list_ids)
    value = cards.map do |card|
      age = (now_utc - card.last_activity_date) / 1.day
      age**exponent
    end.sum

    Datapoint.new value: value.to_i
  end

  metric.configuration = proc do |client, params|
    list_ids = Array(params["list_ids"])
    exponent = params["exponent"] || 2.0
    exponent_options = (1..20).map { |i| i.to_f / 10.0 }

    [
      [:list_ids, select_tag("goal[params][list_ids]",
                             options_for_select(client.list_options,
                                                selected: list_ids),
                             multiple: true,
                             class: "form-control")],

      [:exponent, select_tag("goal[params][exponent]",
                             options_for_select(exponent_options,
                                                selected: exponent),
                             class: "form-control")],
    ]
  end
end
