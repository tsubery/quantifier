class ProvidersController < AuthenticatedController
  expose(:providers) do
    Rails.configuration.provider_names.map do |provider_name|
      find_provider(provider_name).decorate
    end
  end

  expose(:provider) do
    find_provider(params.fetch(:provider_name)).tap do |provider|
      provider.build_goal unless provider.goal
    end
  end

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

  def destroy
    name = provider.name
    provider.destroy!
    redirect_to providers_path, notice: "Deleted #{name}"
  end

  def reload
    BeeminderWorker.new.perform(beeminder_user_id: current_user.beeminder_user_id)
    redirect_to providers_path, notice: "Scores updated."
  end

  private

  def provider_params
    params.require(:provider).permit(
      :uid,
      goal_attributes:
      [
        :slug,
        params: %i(board_id)
      ]
    )
  end

  def find_provider name
    name or raise "Missing provider"
    scope = current_user.providers
    scope.all.includes(:goal).find{ |p| name == p.name} ||
      scope.new(name: name, user: current_user)
  end

  def slug
    params[:provider].fetch(:goal_slug)
  end
end
