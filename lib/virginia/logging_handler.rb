require 'reel'

module Virginia
	class LoggingHandler
		def init
			Reel::Server.supervise(Adhearsion.config[:virginia].host, Adhearsion.config[:virginia].port) do |connection|
				while request = connection.request
					request.respond :ok, "hello, world!"
				end 
			end
		end
	end
end
