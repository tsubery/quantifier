Provider.find(:trello).register_metric :idle_days_linear do |metric|
  metric.description = "Sum of days cards have been idle."
  metric.title = "Idle Days"

  metric.block = Proc.new do |adapter, options|
    now_utc = Time.current.utc
    cards = adapter.cards(options.fetch(:list_ids))
    value = cards.map do |card|
      now_utc - card.last_activity_date
    end.sum / 1.day

    Datapoint.new(timestamp: Time.current.utc, value: value.to_i)
  end

  metric.configuration = Proc.new do |adapter, form|
    list_ids = Array(form.object.params[:list_ids])
    "<tr>
      <td>
        #{form.label(:list_ids)}
      </td>
      <td>
        #{select_tag("[params][list_ids]",
                     options_for_select(adapter.list_options,
                     selected: list_ids),
                     multiple: true)
    }
      </td>
    </tr>"
  end
end
