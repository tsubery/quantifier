class CredentialDecorator < Draper::Decorator
  delegate_all

  def connected_as
    info["nickname"] || info["email"] || uid
  end

  def status
    if connected_as
    "Connected as #{connected_as}"
    else
      "Not Connected"
    end
  end
end
