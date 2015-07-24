class ProviderDecorator < Draper::Decorator
  delegate_all

  def setup_link
    if missing_oauth?
      h.link_to "Connect your #{provider_name} account", "/auth/#{provider_name}"
    else
      h.link_to "Setup #{provider_name} goal", h.provider_edit_path(self)
    end
  end

  def status
    if missing_oauth?
      "Not connected"
    else
      "Connected as #{uid}"
    end
  end

  def to_param
    provider_name
  end

  def provider_name
    object.class.sti_name
  end

  def extra_form_fields(f)
    #none by default
    []
  end
end
