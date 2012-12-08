require 'spec_helper'

describe Job do
  it 'should respond to #tty?' do
    job = Job.new
    job.should respond_to(:tty?)
  end
end
