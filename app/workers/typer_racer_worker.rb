class TyperRacerWorker
  include Sidekiq::Worker

  def perform
    Identity.where(provider: :typeracer).map do |identity|
      beeminder = identity.user.beeminder_client
      goal = beeminder.goal(identity.goal)
      value = TypeRacer::Client.new(identity.uid).completed_games
      goal.add Beeminder::Datapoint.new(value: value)
    end
  end
end
