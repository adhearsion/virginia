#Reel::Server.supervise "0.0.0.0", 80 do |connection|
  #while request = connection.request
    #case request
    #when Reel::Request
      #status, body = case request.url
      #when /call_count/
        #[:ok, Adhearsion.active_calls.count]
      #end
      #connection.respond status, body
    #end
  #end
#end

#client = Faraday.new url: 'http://sushi.com'
#response = client.get '/call_count'
#response.status # => 200
#response.body # => 1_235_234


#module Virginia
  #class Dsl
    #def parse(path)
      #keys = []
      #ignore = ""
      #pattern = path.to_str.gsub(/[^\?\%\\\/\:\*\w]/) do |c|
        #ignore << escaped(c).join if c.match(/[\.@]/)
        #encoded(c)
      #end
      #pattern.gsub!(/((:\w+)|\*)/) do |match|
        #if match == "*"
          #keys << 'splat'
          #"(.*?)"
        #else
          #keys << $2[1..-1]
          #"([^#{ignore}/?#]+)"
        #end
      #end
      #[/\A#{pattern}\z/, keys]
    #end
  #end
  
  #def process_route(route)
    
  #end

#end


# def process_route(pattern, keys, conditions, block = nil, values = [])
      #route = @request.path_info
      #route = '/' if route.empty? and not settings.empty_path_info?
      #return unless match = pattern.match(route)
      #values += match.captures.to_a.map { |v| force_encoding URI.decode_www_form_component(v) if v }

      #if values.any?
        #original, @params = params, params.merge('splat' => [], 'captures' => values)
        #keys.zip(values) { |k,v| Array === @params[k] ? @params[k] << v : @params[k] = v if v }
      #end

      #catch(:pass) do
        #conditions.each { |c| throw :pass if c.bind(self).call == false }
        #block ? block[self, values] : yield(self, values)
      #end
    #ensure
      #@params = original if original
    #end
