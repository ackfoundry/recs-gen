class Ec2
  attr_accessor :options, :client

  def initialize(opts)
    self.options = opts
    self.client = Aws::EC2::Client.new(region: options[:region])
  end

  def describe_instance(id)
    client.describe_instances(
      instance_ids: [id]
    )&.reservations&.map(&:instances)&.flatten&.first
  end
end
