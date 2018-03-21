require 'erb'

class Renderer
  attr_accessor :ctx, :input, :output

  def initialize(ctx)
    self.ctx = ctx
  end

  def render(input, output)
    self.input, self.output = input, output

    validate
    write
  end

  def write
    File.open(output, 'w') { |file| file.write(rendered_output) }
    $logger.debug "Template rendered to #{output}"
  end

  def rendered_output
    ERB.new(
      File.open(input, 'rb', &:read)
    ).result(ctx)
  end

  def validate
    die "Cannot read template file (#{input})" unless File.readable?(input)
  end

  def die(msg)
    $logger.fatal msg
    exit
  end
end
