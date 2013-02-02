module Virginia
  class LoggingHandler
    def self.handle(request)
      logger.info request
      [:ok, "200 OK"] 
    end
  end
end
