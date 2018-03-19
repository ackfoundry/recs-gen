class Listener
  attr_accessor :options, :logger

  def initialize(opts, logger = Logger.new(STDOUT))
    self.options, self.logger = opts, logger
  end

  def run
    logger.info 'Polling for ecs changes...'

    loop do
      logger.info 'Updating config...'
      Scanner.new(options, logger).scan

      if options[:once]
        logger.info "Config written to #{options[:output]}"
        break
      end

      sleep options[:frequency]
    end
  end
end
