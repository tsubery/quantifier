module ThirdPartyMocks

  def generate_fake_goals slug_names
    slug_names.map do |name|
      double slug: name
    end
  end

  def mock_beeminder_goals user, slug_name
    fake_goals = generate_fake_goals(slug_name)
    fake_client = double(goals:  fake_goals)
    allow(user).to receive(:client).and_return(fake_client)
  end

  def mock_trello_boards
    fake_lists = (1..4).map{ |i| [ "List#{i}", i ] }
    allow_any_instance_of(TrelloProvider).to receive(:list_options).and_return(fake_lists)
  end
  def mock_typeracer_validation
    allow_any_instance_of(TyperacerProvider).to receive(:valid_uid?)
  end

  def mock_provider_score provider_name
    fake_scores = [ { Time.at(1437775585) => 12423 } ]
    provider_class = Provider.find_sti_class(provider_name.to_s)
    allow_any_instance_of(provider_class).to receive(:calculate_score).and_return(fake_scores)
  end
end
