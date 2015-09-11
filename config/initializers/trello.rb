require "trello"
Provider.register :trello, auth_type: :oauth, adapter: TrelloAdapter
