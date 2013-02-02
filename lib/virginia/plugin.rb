module Virginia
  class Plugin < Adhearsion::Plugin
    # Actions to perform when the plugin is loaded
    #
    init :virginia do
      logger.warn "Virginia has been loaded"
      Service.start
    end

    # Basic configuration for the plugin
    #
    config :virginia do
      host "0.0.0.0", :desc => "IP to bind the listener to"
      port "8080", :desc => "The port to bind the listener to"
      handler Virginia::LoggingHandler, :desc => "The object that will be handling the requests. Must implement a #handle method that accepts the request object and responds with a status and a body."
    end
  end
end
