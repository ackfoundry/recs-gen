class Context
  attr_accessor :containers

  def template_binding
    self.binding
  end
end
