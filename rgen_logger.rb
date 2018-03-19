require 'logger'

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
    logger.level = LEVELS[opts['log-level']] || Logger::WARN
    logger
  end
end
