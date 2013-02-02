require 'reel'

module Virginia
  class Service
    def self.start
      ::Reel::Server.supervise Adhearsion.config[:virginia].host, Adhearsion.config[:virginia].port do |connection|
        while request = connection.request
          case request
          when Reel::Request
            status, body = Adhearsion.config[:virginia].handler.handle request
            connection.respond status, body
          end
        end
      end
    end
  end
end
