module Container
  def self.extract_from(task, task_definition, container_definition, network_bindings, options, id_ip_map)
    $logger.debug "Extracting #{container_definition.name}"

    if container_definition.name.downcase == options[:task].downcase
      $logger.debug 'Container is own container, skipping'
      return
    end

    net_bindings = network_bindings[container_definition.name]
    if net_bindings.empty?
      $logger.debug 'Container has no network bidings, skipping'
      return
    end

    env = extract_env(container_definition.environment)
    unless raw_hosts = env[options['host-var']&.upcase]
      $logger.warn "[#{container_definition.name}] #{options['host-var'].upcase} environment variable not found, skipping"
      return
    end
    unless raw_ports = env['VIRTUAL_PORTS']
      raw_ports = '7519 7520'
      $logger.warn "[#{container_definition.name}] VIRTUAL_PORTS environment variable not found, skipping"
      return
    end

    return OpenStruct.new(
      name: container_definition.name,
      hosts: raw_hosts.split(' '),
      ports: raw_ports.split(' '),
      env: env,
      address: id_ip_map[task.container_instance_arn]
    )
  end

  def self.extract_env(kvpairs)
    kvpairs.inject({}) do |env, pair|
      env[pair.name] = pair.value
      env
    end
  end

  class Binding
    attr_accessor :containers

    def self.create(containers)
      new(containers).__binding__
    end

    def initialize(containers)
      self.containers = containers
    end
  end
end
