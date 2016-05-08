class MainController < ApplicationController
  expose(:providers) do
    PROVIDERS.map do |name, provider|
      ProviderDecorator.decorate(provider, credentials[name])
    end
  end

  expose(:goals) { current_user && current_user.goals.decorate }
  expose(:credentials) do
    Array(current_user&.credentials).each_with_object({}) do |c, acc|
      acc[c.provider_name] = c
    end.with_indifferent_access
  end
end
