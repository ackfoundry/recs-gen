class Listener
  attr_accessor :options

  def initialize(opts)
    self.options = opts
  end

  def run
    $logger.info 'Polling for ecs changes...'

    loop do
      $logger.info 'Updating config...'
      Scanner.new(options).scan

      if options[:once]
        Scanner.new(options).scan
        break
      end

      sleep options[:frequency]
    end
  end
end
