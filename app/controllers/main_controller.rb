class MainController < ApplicationController
  helper_method def providers
    @_providers ||= PROVIDERS.map do |name, provider|
      ProviderDecorator.new(provider, credentials[name])
    end
  end

  helper_method def goals
    @_goals ||= current_user&.goals&.map(&GoalDecorator.method(:new))
  end

  helper_method def credentials
    @_credentials ||= Array(current_user&.credentials).map do |c|
      [c.provider_name, c]
    end.to_h.with_indifferent_access
  end
end
