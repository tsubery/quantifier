require_relative "../../spec/support/helpers/omniauth"
require_relative "../../spec/support/helpers/third_party_mocks"

RSpec.configure do |config|
  config.include Omniauth::TestHelpers
  config.include ThirdPartyMocks
end
OmniAuth.config.test_mode = true
