class IdentityResolver
  attr_reader :flash, :credential

  def initialize(current_user, auth)
    @auth = auth
    @uid = auth.fetch("uid")
    @provider_name = auth.fetch("provider")
    @current_user = current_user

    set_credential
  end

  private

  attr_reader :auth, :uid, :provider_name, :current_user

  def set_credential
    @credential = find_credential
    return unless current_user || session_credential?
    @credential ||= create_credential(current_user)
    update_credential
  end

  def find_credential
    Credential.find_by(
      provider_name: provider_name,
      uid: uid
    )
  end

  def session_credential?
    "beeminder" == provider_name
  end

  def create_credential(user)
    user ||= User.find_or_create_by!(beeminder_user_id: uid)
    Credential.create!(
      beeminder_user_id: user.beeminder_user_id,
      provider_name: provider_name,
      uid: @uid
    )
  end

  def update_credential
    @credential.update_attributes! @auth.slice("info", "credentials", "extra").to_h
  end
end
