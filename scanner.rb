require './ec2'
require './ecs'
require './signal_runner'

class Scanner
  attr_accessor :options, :ecs, :ec2

  def initialize(opts)
    self.options = opts
    self.ecs = Ecs.new(opts)
    self.ec2 = Ec2.new(opts)
  end

  def scan
    $logger.debug 'Beginning ECS scan...'

    $logger.debug "Config written to #{options[:output]}"

    $logger.error "Signal failed with status #{$?.exitstatus}" unless SignalRunner.run(options)
  end
end
