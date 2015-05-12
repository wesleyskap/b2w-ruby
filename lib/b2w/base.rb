module B2W
  class Base
    def [](key)
      @data[key]
    end

    def initialize(data)
      @data = data
    end

    def persisted?
      self[:persisted]
    end

    def self.get(resource, params = {})
      JSON.parse(execute(:get, "#{endpoint}/#{resource}?#{to_params(params)}"))
    end

    def self.post(resource, payload, &block)
      execute(:post, "#{endpoint}/#{resource}", body: payload, &block)
    end

    def put(resource, path, payload)
      self.class.execute(:put, "#{self.class.endpoint}/#{resource}/#{path}", body: payload)
    end

    def self.execute(method, url, params = {}, &block)
      if params[:body]
        params[:headers] = { content_type: 'application/json;charset=UTF-8' }
        params[:payload] = JSON.generate params[:body]
      end
      begin
        RestClient::Request.execute({ method: method, url: url, user: token }.merge(params), &block)
      rescue RestClient::GatewayTimeout
        sleep 10
        retry
      end
    end

    def self.endpoint
      "https://#{version}.bonmarketplace.com.br"
    end

    def self.token
      B2W.config[:token]
    end

    def self.version
      B2W.config[:sandbox] ? "api-sandbox" : "api-marketplace"
    end

    def self.to_params(params)
      params.map { |key, value| "#{camel_case(key)}=#{value}" }.join "&"
    end

    def self.camel_case(key)
      key.to_s.gsub(/_\w/) { $&.upcase }.gsub(/_/, '')
    end
  end
end
