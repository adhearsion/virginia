require 'spec_helper'

describe Virginia::Service do
  class DummyHandler
    def initialize(host, port)
    end
  end

  let(:host)    { "127.0.0.1" }
  let(:port)    { 8989 }
  let(:options) { {Host: host, Port: port} }

  before :each do
    Adhearsion.stub(:root).and_return '.'
    Adhearsion.config.virginia.host   = host
    Adhearsion.config.virginia.port   = port
    Adhearsion.config.virginia.rackup = 'spec/fixtures/config.ru'
  end

  it "should instantiate the handler" do
    rack_logger = double 'Rack::CommonLogger'
    ::Rack::CommonLogger.should_receive(:new).once.with(TestApp, Adhearsion.logger).and_return rack_logger
    ::Reel::Rack::Server.should_receive(:supervise_as).once.with(:reel_rack_server, rack_logger, options)
    Virginia::Service.start
  end
end

class TestApp
end
