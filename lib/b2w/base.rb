module B2W
  class Base
    def [](key)
      @data[key]
    end

    def initialize(data)
      @data = data
    end

    def self.get(resource, params)
      execute(:get, "#{endpoint}/#{resource}?#{to_params(params)}")["#{resource}s"].map { |params| new params }
    end

    def put(resource, path, payload)
      self.class.execute(:put, "#{self.class.endpoint}/#{resource}/#{path}", payload: payload, headers: { content_type: 'application/json' })
    end

    def self.execute(method, url, params = {})
      JSON.parse(RestClient::Request.execute({ method: method, url: url, user: token, password: token }.merge(params)))
    end

    def self.endpoint
      "https://api-marketplace.submarino.com.br/#{version}"
    end

    def self.token
      B2W.config[:token]
    end

    def self.version
      B2W.config[:sandbox] ? "sandbox" : "v1"
    end

    def self.to_params(params)
      params.map { |key, value| "#{camel_case(key)}=#{value}" }.join "&"
    end

    def self.camel_case(key)
      key.to_s.gsub(/_\w/) { $&.upcase }.gsub(/_/, '')
    end
  end
end
