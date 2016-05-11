class Metric
  attr_reader :key, :block
  attr_accessor :block, :description, :title, :configuration
  attr_writer :param_errors

  def initialize(key)
    @key = key
    @configuration = proc { [] }
    @param_errors = proc { [] }
  end

  def call(*args)
    block.call(*args)
  end

  def param_errors(params)
    @param_errors.call(params)
  end

  def valid?
    [key, block, description, title].all?
  end
end
