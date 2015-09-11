class Datapoint
  attr_accessor :timestamp, :value, :id
  def initialize id: nil, timestamp:, value:
    @id = id
    @timestamp = timestamp
    @value = value
  end

  def to_beeminder
    Beeminder::Datapoint
      .new value: value,
           timestamp: timestamp,
           comment: "Auto-entered by beemind.me for #{timestamp} @ #{Time.current}"

  end

  def ==(other)
    other.instance_of?(self.class) &&
      @id == other.id &&
      @timestamp == other.timestamp &&
      @value == other.value
  end

end
