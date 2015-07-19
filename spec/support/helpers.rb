require_relative '../../spec/support/helpers/omniauth'

RSpec.configure do |config|
  config.include Omniauth::TestHelpers
end
OmniAuth.config.test_mode = true
