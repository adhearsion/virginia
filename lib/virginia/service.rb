require 'reel'

module Virginia
  class Service
    def self.start
      Adhearsion.config[:virginia].handler.new Adhearsion.config[:virginia].host, Adhearsion.config[:virginia].port
    end
  end
end
