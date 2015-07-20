class ProvidersController < AuthenticatedController
  expose(:providers) do
    Rails.configuration.provider_names.map do |provider_name|
      find_provider(provider_name).decorate
    end
  end

  expose(:provider) { find_provider(params[:provider_name]) }

  expose(:available_goal_slugs) do
    [''] + current_user.client.goals.map(&:slug)
  end

  def edit
    if provider.missing_oauth?
      redirect_to providers_path, notice: "Connect your account first."
    else
      render :edit
    end
  end

  def upsert
    provider.transaction do
      provider.update_attributes! provider_params
      redirect_to providers_path, notice: "Updated successfully!"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:error] = provider.errors.full_messages.join(' ')
    render :edit
  end

  private

  def goal_attrs
    {
      goal_attributes: {
        slug: slug,
        _destroy: (slug.empty? ? '1' : '0')
      }
    }
  end

  def provider_params
    params.require(:provider).
      permit(:uid).to_h.
      merge(user: current_user).
      merge(goal_attrs)
  end

  def find_provider name
    name or raise "Missing provider"
    scope = current_user.providers
    scope.all.find{ |p| name == p.name} ||
      scope.new(name: name)
  end

  def slug
    params[:provider].fetch(:goal_slug)
  end
end
