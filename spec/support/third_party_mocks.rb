module ThirdPartyMocks
  def generate_fake_goals(slug_names)
    slug_names.map do |name|
      double slug: name
    end
  end

  def mock_beeminder_goals(user, slug_name)
    fake_goals = generate_fake_goals(slug_name)
    fake_client = double(goals: fake_goals)
    allow(user).to receive(:client).and_return(fake_client)
  end

  def mock_trello_boards
    fake_lists = (1..4).map { |i| ["List#{i}", i] }
    allow_any_instance_of(TrelloAdapter).to receive(:list_options).and_return(fake_lists)
  end

  def mock_typeracer_validation
  end

  def mock_provider_score
    fake_scores = [
      Datapoint.new(timestamp: Time.zone.at(1_437_775_585), value: 12_423),
    ]
    allow_any_instance_of(Metric).to(
      receive(:call).and_return(fake_scores)
    )
  end
end
