class MainController < ApplicationController
 helper_method def providers
    @_providers ||= PROVIDERS.map do |name, provider|
      ProviderDecorator.decorate(provider, credentials[name])
    end
  end

  helper_method def goals
  @_goals ||=  current_user && current_user.goals.decorate
  end
  helper_method def credentials
    @_credentials ||= Array(current_user&.credentials).each_with_object({}) do |c, acc|
      acc[c.provider_name] = c
    end.with_indifferent_access
  end
end
