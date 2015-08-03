class TrelloProviderDecorator < ProviderDecorator
  def extra_form_fields(f)
    [
      [
        f.label(:list_ids),
        h.select_tag("provider[goal_attributes][params][list_ids]", h.options_for_select(list_options, selected: list_ids),  multiple: true )
      ]
    ]
  end
end
