require 'stringio'

module Kernel

  def capture(stream)
    return super if stream.is_a?(String)

    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

end