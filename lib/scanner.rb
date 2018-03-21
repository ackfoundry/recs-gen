class Scanner
  extend Forwardable

  attr_accessor :options, :ecs, :ec2, :name_binding_map

  def_delegators :@ecs, :tasks, :cluster
  def_delegator :@ecs, :container_instance_id_ip_map, :id_ip_map

  def initialize(opts)
    self.options = opts
    self.ecs = Ecs.new(opts)

    name_binding_map = {}
  end

  def scan
    start = Time.now
    $logger.debug "Beginning ECS scan at #{start}..."
    validate_cluster

    render(Container::Binding.create(ecs.extracted_containers))

    $logger.error "Signal failed with status #{$?.exitstatus}" unless SignalRunner.run(options)
    stop = Time.now
    $logger.debug "Scan complete at #{stop} (#{((stop - start) * 1000).round(2)}ms)"
  end

  def validate_cluster
    if cluster.status != 'ACTIVE'
      $logger.error "Cluster #{options[:cluster]} is not active"
      exit
    else
      $logger.debug "Cluster #{options[:cluster]} found"
    end
  end

  def render(ctx)
    Renderer.new(ctx).render(
      options[:template],
      options[:output]
    )
  end
end
