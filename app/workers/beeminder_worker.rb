require "trello" # it is not required by default for some reason

class BeeminderWorker
  include Sidekiq::Worker

  def perform(beeminder_user_id: nil)
    if beeminder_user_id
      filter = { credentials: { beeminder_user_id: beeminder_user_id } }
    else
      filter = {}
    end

    Goal.where.not(slug: "")
      .joins(:credential)
      .where(filter)
      .find_each(&method(:safe_sync))
  end

  private

  def safe_sync(goal)
    goal.transaction { goal.sync }
  rescue => e
    Rollbar.error(e, :goal_id => goal.id)
    logger.error e.backtrace
    logger.error e.inspect
  end
end
