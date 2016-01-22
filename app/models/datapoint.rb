class Datapoint
  attr_accessor :timestamp, :value, :id, :unique
  include Comparable

  alias eql? ==

  def initialize(id: nil, unique: false, timestamp: nil, value:)
    @id = id.to_s
    @timestamp = timestamp
    @value = value.to_f
    @unique = unique
  end

  def to_beeminder
    Beeminder::Datapoint
      .new value: value,
           timestamp: timestamp,
           comment: "Auto-entered by beemind.me for #{timestamp} @ #{Time.current}"
  end

  def <=>(other)
    return nil unless other.instance_of?(self.class)
    @value.<=>(other.value) if @id == other.id && @timestamp == other.timestamp
  end

  def hash
    [self.class, @id, @timestamp, @value].hash
  end
end
