class Datapoint
  attr_reader :timestamp, :value, :id, :unique, :comment_prefix
  include Comparable

  alias eql? ==

  def initialize(id: nil, unique: false, timestamp: nil,
                 value:, comment_prefix: "")
    @id = id.to_s
    @timestamp = timestamp
    @value = value.to_d
    @unique = unique
    @comment_prefix = comment_prefix
  end

  def to_beeminder
    Beeminder::Datapoint
      .new value: value,
           timestamp: timestamp,
           comment: "#{comment_prefix} beemind.me for #{timestamp} @ #{Time.current}"
  end

  def <=>(other)
    return nil unless other.instance_of?(self.class)
    @value.<=>(other.value) if @id == other.id && @timestamp == other.timestamp
  end

  def hash
    [self.class, @id, @timestamp, @value].hash
  end
end
