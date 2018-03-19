module RgenLogger
  LEVELS = {
    'fatal'   => Logger::FATAL,
    'error'   => Logger::ERROR,
    'warn'    => Logger::WARN,
    'info'    => Logger::INFO,
    'debug'   => Logger::DEBUG
  }.freeze

  def self.logger(opts)
    logger = Logger.new(STDOUT)
    logger.level = LEVELS[opts[:loglevel]] || Logger::WARN
    logger.info "Log level set to #{logger.level}"
    logger
  end
end
