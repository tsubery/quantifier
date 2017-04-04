class CallbackController < ActionController::Base

  def reload_slug
    if params["slug"].nil?
      render status: 422, json: {"errors" => ["missing slug parameter"]}
    elsif params["username"].nil?
      render status: 422, json: {"errors" => ["missing username parameter"]}
    elsif (goal = find_by_slug(params)).nil?
      render status: 404, json: {"errors" => ["goal not found"]}
    else
      BeeminderWorker.new.perform(goal_id: goal.id)
      render status: 200, json: {}
    end
  end

  def find_by_slug(params)
    Goal.joins(:credential).find_by(slug: params["slug"], credentials: {beeminder_user_id: params["username"]})
  end
end
