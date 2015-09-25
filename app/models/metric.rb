class Metric
  attr_reader :key, :block
  attr_accessor :block, :description, :title, :configuration

  def initialize key
    @key = key
    @configuration = Proc.new { [] }
  end

  def call *args
    block.call *args
  end

  def valid?
    [key, block, description, title].all?
  end

end
