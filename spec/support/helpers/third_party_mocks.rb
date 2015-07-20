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

  def mock_typeracer_validation
    allow_any_instance_of(TyperacerProvider).to receive(:valid_uid?)
  end
end
