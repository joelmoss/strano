require 'stringio'

module Kernel

  # A wrapper for Kernel#system that logs the command being executed.
  def system(*args)
    cmd = args.join(' ')
    result = nil
    if RUBY_PLATFORM =~ /win32/
      cmd = cmd.split(/\s+/).collect {|w| w.match(/^[\w+]+:\/\//) ? w : w.gsub('/', '\\') }.join(' ') # Split command by spaces, change / by \\ unless element is a some+thing://
      cmd.gsub!(/^cd /,'cd /D ') # Replace cd with cd /D
      cmd.gsub!(/&& cd /,'&& cd /D ') # Replace cd with cd /D
      logger.trace "executing locally: #{cmd}"
      elapsed = Benchmark.realtime do
        result = %x[cmd]
      end
    else
      logger.trace "executing locally: #{cmd}"
      elapsed = Benchmark.realtime do
        result = %x[#{cmd}]
      end
    end

    logger.trace "command finished in #{(elapsed * 1000).round}ms"
    $stderr.puts result
  end

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