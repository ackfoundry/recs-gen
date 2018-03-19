module Listener
  def self.start(opts, logger = Logger.new(STDOUT))
    if opts[:once]
      logger.info 'Running template generation once...'
    else
      logger.info 'Polling for ecs changes...'
    end
  end
end
