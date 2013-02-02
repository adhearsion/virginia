require "adhearsion"
require "active_support/dependencies/autoload"
require "virginia/version"
require "virginia/logging_handler"
require "virginia/plugin"

module Virginia
  extend ActiveSupport::Autoload
  autoload :Plugin
  autoload :Service
  autoload :LoggingHandler
end
