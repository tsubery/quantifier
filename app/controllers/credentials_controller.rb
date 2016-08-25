class CredentialsController < AuthenticatedController
  helper_method def credential
    @_credential ||= 
      begin
        collection = current_user.credentials
        credential = collection.find_by(id: params[:id])
        credential ||= collection.find_or_initialize_by(
          provider_name: params_provider_name
        )
        CredentialDecorator.new(credential)
      end
  end

  helper_method delegate :provider, to: :credential

  before_action :require_provider

  def new
    if credential.persisted?
      redirect_to root_path
    elsif provider.oauth?
      redirect_to "/auth/#{provider.name}"
    else
      render :edit
    end
  end

  def create
    update
  end

  def update
    unless credential.update_attributes credential_params
      flash[:error] = credential.errors.full_messages.join(" ")
    end
    redirect_to root_path
  end

  def destroy
    credential.destroy!
    redirect_to root_path, notice: "Credential deleted"
  end

  private

  def credential_params
    if provider.public? || provider.password_auth?
      params.require(:credential).permit(:uid, :password)
    else
      {}
    end
  end

  def params_provider_name
    params[:provider_name] || (params[:credential] || {})[:provider_name]
  end

  def require_provider
    render(status: 404) if provider.nil?
  end
end
