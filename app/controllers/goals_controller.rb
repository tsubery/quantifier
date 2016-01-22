class GoalsController < AuthenticatedController
  expose(:goal) do
    goal = if params[:id]
             current_user.goals.where(id: params[:id]).first
           else
             credential.goals.find_or_initialize_by(metric_key: metric.key)
           end
    fail ActiveRecord::RecordNotFound if goal.nil?
    goal.decorate
  end
  expose(:provider) { ProviderRepo.find(params[:provider_name]) }
  expose(:metric) { provider.find_metric(params[:metric_key]) }
  expose(:credential) do
    current_user.credentials.where(provider_name: provider.name).first
  end

  expose(:available_goal_slugs) do
    current_user.client.goals.map(&:slug)
  end

  def edit
    if credential.nil?
      redirect_to new_credential_path(provider_name: provider.name)
    else
      render :edit
    end
  end

  def upsert
    if goal.update_attributes goal_params
      redirect_to root_path, notice: "Updated successfully!"
    else
      flash[:error] = goal.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    goal.destroy!
    redirect_to root_path, notice: "Deleted successfully!"
  end

  def reload
    BeeminderWorker.new.perform(beeminder_user_id: current_user.beeminder_user_id)
    redirect_to root_path, notice: "Scores updated."
  end

  private

  def goal_params
    params.require(:goal)
          .permit(:id, :slug, :params, :active,
                  params: [
                    :exponent, :timezone, :bed_time_hour, :bed_time_minute,
                    list_ids: []
                  ]
                 )
  end
end
