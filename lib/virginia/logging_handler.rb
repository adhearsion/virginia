require 'reel'
require 'reel/app'

module Virginia
  class LoggingHandler
    include Reel::App
    get "/" do
      logger.info "Virginia request received"
      [:ok, "200 OK"] 
    end
  end
end
