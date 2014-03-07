module Virginia
  class Plugin < Adhearsion::Plugin

    run :virginia do
      logger.info "Virginia has been loaded"
      Service.start
    end

    config :virginia do
      host "0.0.0.0", :desc => "IP to bind the listener to"
      port "8080", :desc => "The port to bind the listener to"
      handler Virginia::LoggingHandler, :desc => "The object that will be handling the requests.  Must be a Reel:App."
    end
  end
end
