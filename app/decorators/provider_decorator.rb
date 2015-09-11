class ProviderDecorator < Draper::Decorator
  delegate_all

  def connected?
    !missing_oauth?
  end

  def auth_link
    "/auth/#{provider_name}"
  end

  def setup_link
    if missing_oauth?
      h.link_to "Connect #{provider_name}",  auth_link
    else
      h.link_to "Setup #{provider_name}", h.provider_edit_path(self)
    end
  end

  def delete_link
    if oauth? && connected?
      h.link_to "Disconnect",
                h.provider_destroy_path(self),
                method: :delete,
                "data-confirm": "Are you sure?"
    else
      "-"
    end
  end

  def status
    if oauth?
      if connected?
        uid ? "Connected as #{connected_user}" : "Connected"
      else
        "Not connected"
      end
    else
      "-"
    end
  end

  def connected_user
    info["nickname"] || info["email"] || uid
  end

  def to_param
    provider_name
  end

  def provider_name
    object.class.sti_name
  end

  def extra_form_fields(_f)
    # none by default
    []
  end

  def extra_status
    ""
  end
end
