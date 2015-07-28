require 'trello' #it is not required by default for some reason

class BeeminderWorker
  include Sidekiq::Worker

  def perform
    Goal.joins(:provider).each do |goal|
      calculate_goal(goal)
    end
  end

  private

  def calculate_goal goal
    goal.transaction do
      provider = goal.provider
      scores = provider.calculate_score(relative: true)
      last_of_values = scores.values.last

      unless provider.deltable? &&
          last_of_values == goal.last_value
        add_datapoints goal, scores
        goal.last_value = last_of_values
        goal.save!
      end
    end
  rescue => e
    p e.backtrace
    p e.inspect
  end

  def datapoint value, timestamp = nil

  end

  def add_datapoints goal, scores
    return if scores.empty?
    bclient = goal.provider.user.client
    bgoal = bclient.goal(goal.slug)
    scores.map do |ts,value|
      Beeminder::Datapoint.new(value: value, timestamp: ts)
    end.each do |datapoint|
      bgoal.add datapoint
    end
  end
end
