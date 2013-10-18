require 'reel'

module Virginia
	class LoggingHandler
		def initialize(host, port)
			Reel::Server.supervise(host, port) do |connection|
				while request = connection.request
					request.respond :ok, "hello, world!"
				end 
			end
		end
	end
end
