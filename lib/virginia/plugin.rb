module Virginia
  class Plugin < Adhearsion::Plugin
    # Actions to perform when the plugin is loaded
    #
    init :virginia do
      logger.warn "Virginia has been loaded"
    end

    # Basic configuration for the plugin
    #
    config :virginia do
      greeting "Hello", :desc => "What to use to greet users"
    end

    # Defining a Rake task is easy
    # The following can be invoked with:
    #   rake plugin_demo:info
    #
    tasks do
      namespace :virginia do
        desc "Prints the PluginTemplate information"
        task :info do
          STDOUT.puts "Virginia plugin v. #{VERSION}"
        end
      end
    end

  end
end
