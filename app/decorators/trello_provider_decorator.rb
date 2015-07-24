class TrelloProviderDecorator < ProviderDecorator
  def extra_form_fields(f)
    [
      [
        f.label(:board_id),
        f.select(:board_id, board_options)
      ]
    ]
  end
end
