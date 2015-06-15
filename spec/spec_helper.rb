require 'adhearsion'
require 'virginia'
require 'timecop'

ENV['AHN_ENV'] = 'test'

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

