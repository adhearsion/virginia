require 'spec_helper'

describe Virginia::Service do
  class DummyHandler
    def initialize(host, port)
    end
  end

  let(:host) { "127.0.0.1" }
  let(:port) { 8989 }
  let(:handler) { DummyHandler }
  before :all do
    Adhearsion.config.virginia.host = host
    Adhearsion.config.virginia.port = port
    Adhearsion.config.virginia.handler = handler
  end

  it "should instantiate the handler" do
    handler.should_receive(:new).with(host, port)
    Virginia::Service.start
  end
end