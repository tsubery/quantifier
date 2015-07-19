class ProvidersController < AuthenticatedController
  expose(:providers) do
    Rails.configuration.provider_names.map do |provider_name|
      decorator = ActiveSupport::Dependencies.constantize(provider_name.camelize + "ProviderDecorator")
      decorator.new current_user.providers.all.find{ |p| provider_name == p.name}
    end
  end
end
