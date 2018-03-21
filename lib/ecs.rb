class Ecs
  attr_accessor :options, :client, :ec2

  def initialize(opts)
    self.options = opts
    self.client = Aws::ECS::Client.new(region: options[:region])
    self.ec2 = Ec2.new(options)
  end

  def cluster
    @cluster ||= client.describe_clusters(
      clusters: [
        options[:cluster]
      ]
    )&.clusters&.first
  end

  def tasks
    @tasks ||= begin
                 task_arns = client.list_tasks(
                   cluster: options[:cluster]
                 ).task_arns
                 tasks = client.describe_tasks(
                   cluster: options[:cluster],
                   tasks: task_arns
                 ).tasks
               end
  end

  def container_instance_id_ip_map
    container_instances.inject({}) do |map, instance|
      ec2_instance = ec2.describe_instance(instance.ec2_instance_id)
      map[instance.container_instance_arn] = ec2_instance.private_ip_address
      map
    end
  end

  def container_instance_arns
    @container_instances ||= client.list_container_instances(
      cluster: options[:cluster]
    ).container_instance_arns
  end

  def container_instances
    @container_instances ||= client.describe_container_instances(
      cluster: options[:cluster],
      container_instances: container_instance_arns
    )&.container_instances
  end

  def extracted_containers
    @extracted_containers ||= begin
                                tasks.inject([]) do |containers, t|
                                  td = task_definition_for(t)

                                  net_binding = t.containers.inject({}) do |map, c|
                                    map[c.name] = c.network_bindings
                                    map
                                  end

                                  td.container_definitions.each do |cd|
                                    containers << Container.extract_from(t, td, cd, net_binding, options, container_instance_id_ip_map)
                                  end

                                  containers
                                end.compact
                              end
  end

  def task_definition_for(task)
    td = client.describe_task_definition(
      task_definition: task.task_definition_arn
    ).task_definition
  end
end
