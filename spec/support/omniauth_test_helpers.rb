module OmniauthTestHelpers
  FAKE_AUTH_ATTR = {
    "uid" => "mock_uid",
    "user_info" => {
      "name" => "mockuser",
      "image" => "mock_user_thumbnail_url",
    },
    "credentials" => {
      "token" => "mock_token",
      "secret" => "mock_secret",
    },
  }.freeze
  def mock_auth(provider = :beeminder)
    OmniAuth.config.mock_auth = {}
    OmniAuth.config.mock_auth[provider] = FAKE_AUTH_ATTR.merge(
      "provider" => provider.to_s
    )
  end

  def mock_current_user(user = build_stubbed(:user))
    allow_any_instance_of(ApplicationController).to(
      receive(:current_user).and_return(user)
    )
    user
  end
end
