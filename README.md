# Virginia [![Build Status](https://travis-ci.org/adhearsion/virginia.svg?branch=develop)](https://travis-ci.org/adhearsion/virginia)

Virginia is a Reel interface to Adhearsion, named after a dance originating in the 17th century, the Virginia Reel. Now your web apps can dance with your voice apps!

Virginia allows you to bundle a simple web interface in your Adhearsion application. You can use any Rack-compatible framework with Reel.

## Configuration

The plugin defines three configuration keys.

* host: Which IP to bind on (defaults to 0.0.0.0)
* port: Which port to listen on (defaults to 8080)
* rackup: Location of the Rackup configuration file (defaults to config.ru)

## Sinatra Example

This example uses Sinatra, but this should work with any Rack-compatible framework.

### Update Gemfile

Add the framework gem to your Gemfile, in our case, Sinatra:

```Ruby
gem 'sinatra'
```

Don't forget to run `bundle install`.

### Create the app

Here is a simple "Hello World" app in Sinatra. Place this in `lib/sinatra_app.rb`:

```Ruby
require 'sinatra'

get '/' do
  'Hello world!'
end
```

### Configure Rack

Finally, tell Rack how to start your web app. Place this in `config.ru`:

```Ruby
require "#{Adhearsion.root}/lib/sinatra_app.rb"
run Sinatra::Application
```

### Test the app

Start Adhearsion.  You should be able to visit `http://localhost:8080/` in your browser and see "Hello world!"

## Using the built-in document cache

Assuming you are using Sinatra like in the above examples, put this in your `lib/sinatra_app.rb`:

```Ruby
require 'sinatra'

get '/documents/:id' do
  begin
    document = Virginia::DocumentCache.fetch params[:id]
    headers['Content-Type'] = document.content_type
    document.body
  rescue Virginia::DocumentCache::NotFound
    raise Sinatra::NotFound
  end
end
```

Then, to store a document in the cache, do this in your CallController:

```Ruby
cache_id = Virginia::DocumentCache.store 'Hello World!'
virginia_config = Adhearsion.config.virginia
logger.info "Document has been cached to http://#{virginia_config.host}:#{virginia_config.port}/documents/#{cache_id}"
```

You should be able to retrieve the document at the logged URL.


### Contributors

Original author: [Luca Pradovera](https://github.com/polysics)

Contributors:
* [Ben Klang](https://github.com/bklang)

### Links

* [Adhearsion](http://adhearsion.com)
* [Source](https://github.com/adhearsion/adhearsion-asterisk)
* [Documentation](http://rdoc.info/github/adhearsion/adhearsion-asterisk/master/frames)
* [Bug Tracker](https://github.com/adhearsion/adhearsion-asterisk/issues)

### Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  * If you want to have your own version, that is fine but bump version in a commit by itself so I can ignore when I pull
* Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright (c) 2012-2014 Adhearsion Foundation Inc. MIT license (see LICENSE for details).
