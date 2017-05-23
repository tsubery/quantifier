class CallbackController < ActionController::Base

  def reload_slug
    if params["slug"].nil?
      render status: 422, json: {"errors" => ["missing slug parameter"]}
    elsif params["username"].nil?
      render status: 422, json: {"errors" => ["missing username parameter"]}
    elsif (goal = find_by_slug(params)).nil?
      render status: 404, json: {"errors" => ["goal not found"]}
    else
      begin
        BeeminderWorker.new.perform(goal_id: goal.id)
        render status: 200, json: {}
      rescue Timeout::Error
        logger.error "Timeout syncing goal ##{goal.id}"
        render status: 504, json: {}
      end
    end
  end

  def find_by_slug(params)
    Goal.joins(:credential).find_by(slug: params["slug"], credentials: {beeminder_user_id: params["username"]})
  end
end
