class CredentialDecorator < Draper::Decorator
  delegate_all

  def connected_as
    info["nickname"] || info["email"] || uid
  end

  def status
    if connected_as.present?
      "Connected as #{connected_as}"
    else
      "Click to connect"
    end
  end
end
