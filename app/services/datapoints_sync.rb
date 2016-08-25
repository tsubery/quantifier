class DatapointsSync
  def initialize(calculated, stored, beeminder_goal)
    @stored = stored
    @calculated = calculated
    @beeminder_goal = beeminder_goal
    last_value = stored.last && stored.last.value
    @new_datapoints = (calculated - stored).reject do |dp|
      dp.timestamp.nil? && last_value == dp.value
    end
  end

  def call
    to_delete = overlapping_datapoints(new_datapoints, stored)
    transmit new_datapoints
    to_delete.each(&beeminder_goal.method(:delete))
  end

  def storable
    return [] if new_datapoints.empty?
    calculated
  end

  private

  attr_reader :stored, :calculated, :new_datapoints, :beeminder_goal

  def transmit(datapoints)
    return if datapoints.empty?
    beeminder_goal.add datapoints.map(&:to_beeminder)
  end

  def overlapping_datapoints(new_datapoints, stored)
    timestamps = overlapping_timestamps(new_datapoints, stored)
    return [] if timestamps.empty?
    beeminder_goal.datapoints.select do |dp|
      timestamps.include?(dp.timestamp)
    end
  end

  def overlapping_timestamps(new_datapoints, stored)
    (new_datapoints.map(&:timestamp) & stored.map(&:timestamp)).to_set
  end
end
