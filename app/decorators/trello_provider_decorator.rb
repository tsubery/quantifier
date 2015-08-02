class TrelloProviderDecorator < ProviderDecorator
  def extra_form_fields(f)
    [
      [
        f.label(:board_id),
        f.select(:board_id, board_options, selected: board_id)
      ]
    ]
  end
  def extra_status
    "selected board_id: #{goal.params['board_id']}"
  end
end
