class Github::Base
  
  METHODS = [ :get, :post, :put, :delete, :patch ]
  METHODS_WITH_BODIES = [ :post, :put, :patch ]


  def initialize(access_token)
    @access_token = access_token
  end

  METHODS.each do |m|
    define_method m do |path, params = {}, options = {}|
      request m, path, params, options
    end
  end
  
  
  private
  
    def request(method, path, params, options)
      raise ArgumentError, "unknown http method: #{method}" unless METHODS.include?(method)

      response = connection(options).send(method) do |request|
        case method.to_sym
          when *(METHODS - METHODS_WITH_BODIES)
            request.url path, params
          when *METHODS_WITH_BODIES
            request.path = path
            request.body = MultiJson.encode(params) unless params.empty?
        end
      end
      
      response.body
    end
    
    def connection(options = {})
      @connection ||= FaradayStack.build header_options.merge(options) do |builder|
        builder.use Faraday::Response::Mashify
      end
    end
  
    def header_options
      {
        :headers => {
          'Accept'        => '*/*',
          'User-Agent'    => "Strano",
          'Content-Type'  => 'application/json',
          'Authorization' => "token #{@access_token}"
        },
        :ssl => { :verify => false },
        :url => 'https://api.github.com'
      }
    end
  
end