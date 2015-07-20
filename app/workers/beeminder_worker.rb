class BeeminderWorker
  include Sidekiq::Worker

  def perform
    Goal.joins(:provider).map do |goal|
      update_goal_value goal, goal.provider.calculate_score
    end
  end

  private
  def update_goal_value goal, value
    return if value == goal.last_value
    goal.transaction do
      goal.update last_value: value
      goal.provider.user.client.send goal.slug, value
    end
  end
end
