class IdentityResolver
  attr_reader :sign_in_user, :flash

  # rubocop:disable all
  def initialize(current_user, auth)
    @auth = auth

    if session_credential?
      if current_user
        @flash = "Already signed in!"
      else
        @sign_in_user = upsert_user
        @flash = "Signed in!"
      end
    else
      if (credential = find_credential_for_uid)
        # It's a known credential
        if current_user
          if current_user != credential.user
            @flash = "User #{uid} belongs to another user."
          else
            @flash = "Credentials already exists."
          end
        else
          @sign_in_user = credential.user
          @flash = "Signed in!"
        end
      else
        # First time we encounter this credential
        if !current_user
          # We must have a sign in user to create the credential
          @flash = "Please sign in first."
        elsif find_credential_for_user(current_user)
          @flash = "Provider already connected with #{uid}"
        else
          create_credential_for current_user
          @flash = "Connected successfully. Click Setup to complete the process!"
        end
      end
    end
  end
  # rubocop:enable all

  private

  def provider_name
    @auth.fetch("provider")
  end

  def uid
    @auth.fetch "uid"
  end

  def beeminder_token
    @auth.fetch("credentials").fetch("token")
  end

  def find_credential_for_uid
    Credential.find_by(
      provider_name: provider_name,
      uid: uid
    )
  end

  def find_credential_for_user(user)
    user.credentials.find_by provider_name: provider_name
  end

  def session_credential?
    "beeminder" == provider_name
  end

  def create_credential_for(user)
    params = @auth.slice("uid", "info", "credentials", "extra").to_h
    Credential.create! params.merge(user: user, provider_name: provider_name)
  end

  def upsert_user
    User.upsert uid, beeminder_token
  end
end
