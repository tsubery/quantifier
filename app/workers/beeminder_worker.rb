require "trello" # it is not required by default for some reason

class BeeminderWorker
  include Sidekiq::Worker

  def perform(beeminder_user_id: nil)
    if beeminder_user_id
      filter = { providers: { beeminder_user_id: beeminder_user_id } }
    else
      filter = {}
    end

    Goal.where.not(slug: "")
      .joins(:provider).where(filter).find_each do |goal|
      safe_calculate_goal(goal, goal.provider)
    end
  end

  private

  def safe_calculate_goal(goal, provider)
    goal.transaction do
      calculate_goal goal, provider
    end
  rescue => e
    logger.error e.backtrace
    logger.error e.inspect
  end

  def calculate_goal(goal, provider)
    scores = provider.calculate_score(relative: true)

    if !provider.deltable? &&
       scores.values.last != goal.last_value
      add_datapoints goal, scores
      goal.update! last_value: scores.values.last
    elsif provider.deltable?
      add_datapoints goal, scores
    end
  end

  def add_datapoints(goal, scores)
    return if scores.empty?
    bclient = goal.provider.user.client
    bgoal = bclient.goal(goal.slug)
    bgoal.add scores.map do |ts, value|
      Beeminder::Datapoint
        .new value: value,
             timestamp: ts,
             comment: "Auto-entered by beemind.me for #{ts} @ #{Time.current}"
    end
  end
end
