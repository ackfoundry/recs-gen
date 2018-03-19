module SignalRunner
  def self.run(opts)
    $logger.debug "Executing signal (#{opts[:signal]})..."
    system(opts[:signal])
  end
end
