module Omniauth
  module TestHelpers
    # rubocop:disable MethodLength
    def mock_auth(provider = :beeminder)
      OmniAuth.config.mock_auth = {}
      OmniAuth.config.mock_auth[provider] = {
        "provider" => provider.to_s,
        "uid" => "mock_uid",
        "user_info" => {
          "name" => "mockuser",
          "image" => "mock_user_thumbnail_url"
        },
        "credentials" => {
          "token" => "mock_token",
          "secret" => "mock_secret"
        }
      }
    end
    # rubocop:enable all
    #
    def mock_current_user(user = build_stubbed(:user))
      allow_any_instance_of(ApplicationController).to(
        receive(:current_user).and_return(user)
      )
      user
    end
  end
end
