class Scanner
  attr_accessor :options, :logger

  def initialize(opts, logger = Logger.new(STDOUT))
    self.options, self.logger = opts, logger
  end

  def scan
    logger.debug 'Beginning ECS scan...'
  end
end
