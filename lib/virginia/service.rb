# encoding: utf-8
require 'reel'
require 'reel/rack'

module Virginia
  class Service
    def self.start
      config = Adhearsion.config.virginia

      # Rack-compatible options
      app, options = ::Rack::Builder.parse_file File.join(Adhearsion.root, config[:rackup])
      options = {
        Host: config[:host],
        Port: config[:port]
      }.merge(options)

      app = Rack::CommonLogger.new(app, Adhearsion.logger)
      supervisor = ::Reel::Rack::Server.supervise_as(:reel_rack_server, app, options)

      Adhearsion::Events.register_callback :shutdown do
        supervisor.terminate
      end
    end
  end
end
