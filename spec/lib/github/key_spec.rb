require "spec_helper"

describe Github::Key do

  let(:github) { Github.new('somerandomkey') }

  describe "#create" do
    use_vcr_cassette :erb => true

    it { github.key.create("Strano", ENV['STRANO_PUBLIC_SSH_KEY']) }
  end

end
