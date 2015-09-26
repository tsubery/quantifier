class Datapoint
  attr_accessor :timestamp, :value, :id
  include Comparable

  alias_method :eql?, :==

  def initialize(id: nil, timestamp:, value:)
    @id = id.to_s
    @timestamp = timestamp
    @value = value.to_f
  end

  def to_beeminder
    Beeminder::Datapoint
      .new id: id,
           value: value,
           timestamp: timestamp,
           comment: "Auto-entered by beemind.me for #{timestamp} @ #{Time.current}"
  end

  def <=>(other)
    return nil unless other.instance_of?(self.class)
    if @id == other.id && @timestamp == other.timestamp
      @value.<=>(other.value)
    else
      nil
    end
  end

  def hash
    [self.class, @id, @timestamp, @value].hash
  end
end
