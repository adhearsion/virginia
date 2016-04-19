# encoding: utf-8

require 'virginia/service'
require 'virginia/document_cache'

module Virginia
  class Plugin < Adhearsion::Plugin

    run :virginia do
      logger.info "Virginia has been loaded"
      Service.start

      # Document Cache
      supervisor = Virginia::DocumentCache.supervise_as(:virginia_document_cache)
      Adhearsion::Events.register_callback :shutdown do
        supervisor.terminate
      end
    end

    config :virginia do
      host "0.0.0.0", :desc => "IP to bind the listener to"
      port "8080", :desc => "The port to bind the listener to"
      rackup 'config.ru', desc: 'Rack configuration file (relative to Adhearsion application root)'
    end
  end
end
