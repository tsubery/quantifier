class DatapointsSync
  def initialize(calculated, stored, beeminder_goal)
    @calculated = calculated
    @stored = stored
    @beeminder_goal = beeminder_goal
    @new_datapoints = (calculated - stored)
  end

  def call
    delete overlapping_timestamps(new_datapoints, stored)
    transmit new_datapoints
  end

  private

  attr_reader :stored, :calculated, :new_datapoints, :beeminder_goal

  def transmit(datapoints)
    return if datapoints.empty?
    beeminder_goal.add datapoints.map(&:to_beeminder)
  end

  def delete(timestamps)
    return if timestamps.empty?
    beeminder_goal.datapoints.select do |dp|
      timestamps.include?(dp.timestamp)
    end.each(&beeminder_goal.method(:delete))
  end

  def overlapping_timestamps(new_datapoints, stored)
    new_datapoints.map(&:timestamp) & stored.map(&:timestamp)
  end
end
