class Container < OpenStruct
  def self.extract_from(task, task_definition, container_definition, network_bindings, options, id_ip_map)
    $logger.debug "Extracting #{container_definition.name}"

    if container_definition.name.downcase == options[:task].downcase
      $logger.warn 'Container is own container, skipping'
      return
    end

    net_bindings = network_bindings[container_definition.name]
    if net_bindings.nil? || net_bindings.empty?
      $logger.warn 'Container has no network bidings, skipping'
      return
    end

    env = extract_env(container_definition.environment)
    unless raw_hosts = env[options['host-var']&.upcase]&.split(' ')
      $logger.warn "[#{container_definition.name}] #{options['host-var'].upcase} environment variable not found, skipping"
      return
    end
    unless raw_ports = env['VIRTUAL_PORTS']&.split(' ')
      raw_ports = '7519 7520'
      $logger.warn "[#{container_definition.name}] VIRTUAL_PORTS environment variable not found, skipping"
      return
    end

    host_ports = extract_host_ports(raw_ports, net_bindings)

    return new(
      name: container_definition.name,
      hosts: raw_hosts,
      ports: extract_host_ports(raw_ports, net_bindings),
      env: env,
      address: id_ip_map[task.container_instance_arn],
      ingress_map: build_ingress_map(raw_ports, host_ports, raw_hosts)
    )
  end

  def self.build_ingress_map(raw_ports, host_ports, hostnames)
    raw_ports.inject({}) do |map, rp|
      i = raw_ports.index(rp)
      map[rp.to_i] = {
        hostname: hostnames[i],
        port: host_ports[i]
      }
      map
    end
  end

  def self.extract_env(kvpairs)
    kvpairs.inject({}) do |env, pair|
      env[pair.name] = pair.value
      env
    end
  end

  def self.extract_host_ports(virtual_ports, network_bindings)
    virtual_ports.map do |vp|
      network_bindings.find {|b| b.container_port == vp.to_i }&.host_port
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
