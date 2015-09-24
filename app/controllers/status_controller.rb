class StatusController < AuthenticatedController
  expose(:goals) { current_user.goals.decorate }

  def reload
    BeeminderWorker.new.perform(beeminder_user_id: current_user.beeminder_user_id)
    redirect_to providers_path, notice: "Scores updated."
  end
end
