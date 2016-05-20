PROVIDERS.fetch(:trello).register_metric :idle_hours_rmp do |metric|
  metric.description = 'The root mean power of the ages of the cards measured in hours.
  Power of 2 is the same as calculating the "Root Mean Square" of the ages.'
  metric.title = "Cards age RMP"

  metric.block = proc do |adapter, options|
    exponent = (options["exponent"] || 2.0).to_f
    now_utc = Time.current.utc
    list_ids = Array(options["list_ids"])
    cards = adapter.cards(list_ids)
    sum = cards.map do |card|
      age = (now_utc - card.last_activity_date) / 1.hour
      age**exponent
    end.sum
    value = sum.zero? ? sum : Math.sqrt(sum / cards.count)

    Datapoint.new value: value.to_i
  end

  metric.configuration = proc do |client, params|
    list_ids = Array(params["list_ids"])
    exponent = params["exponent"] || 2.0
    exponent_options = (1..100).map { |i| i.to_f / 10.0 }

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
