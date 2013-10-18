require 'reel'

module Virginia
	class LoggingHandler
		def initialize(host, port)
			Reel::Server.supervise(host, port) do |connection|
				connection.each_request do |request|
					request.respond :ok, "Hello, world!"
				end
			end
		end
	end
end
