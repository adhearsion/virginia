require "adhearsion"
%w(
  version
  plugin
  service
  document_cache
).each { |file| require "virginia/#{file}" }

module Virginia
end
