class Ecs
  attr_accessor :options, :client

  def initialize(opts)
    self.options = opts
    self.client = Aws::ECS::Client.new(region: options[:region])
  end

  def describe_cluster(name)

  end

  def container_instances(cluster)

  end

  def describe_container_instances(cluster, arns)

  end

  def services(cluster)

  end

  def describe_services(cluster, arns)

  end

  def tasks(cluster)

  end

  def describe_tasks(cluster, arns)

  end

  def describe_task_definition(arn)

  end
end
