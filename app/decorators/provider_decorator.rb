class ProviderDecorator < Draper::Decorator
  delegate_all

  def status
    if object
      h.link_to "configure #{uid}@#{provider_name}", "/providers/#{provider_name}/configure"
    else
      h.link_to "Connect your #{provider_name} account", "auth/#{provider_name}"
    end
  end

  def provider_name
    raise NotImplementedError
  end
end
