class MainController < ApplicationController
  expose(:providers) do
    ProviderRepo.names.map do |name|
      provider = ProviderRepo.find!(name)
      ProviderDecorator.decorate(provider, credentials[name])
    end
  end

  expose(:goals) { current_user && current_user.goals.decorate }
  expose(:credentials) do
    if current_user
      current_user.credentials.each_with_object({}) do |c,acc|
        acc[c.provider_name.to_sym] = c
      end
    else
      {}
    end
  end

  def about
  end
end
