require 'reel'

module Virginia
  class Service
    def self.start
      handler = Adhearsion.config[:virginia].handler.new
      handler.init
    end
  end
end
