# Virginia

Virginia is a Reel interface to Adhearsion, named after a dance originating in the 17th, the Virginia Reel.

It allows you to bundle a simple, Sinatra-style web interface with your Adhearsion application, enabling use of all the available APIs.

## Configuration

The plugin defines three configuration keys.

* host: Which IP to bind on (defaults to 0.0.0.0)
* port: Which port to listen on (defaults to 8080)
* handler: the Reel::App class to use (see below)

## Handler
Virginia bundles a simple logging handler class that will answer to GET on "/" with OK and prints a log message in the Adhearsion console.

An example handler, implementing click-to-call, would be built as follows:

```ruby
require 'reel'
require 'reel/app'

class RequestHandler
  include Reel::App
  get('/dial') do
    Adhearsion::OutboundCall.originate "SIP/100"  do
      invoke ConnectingController
    end
    [200, {}, "200 OK"]
  end
end
```