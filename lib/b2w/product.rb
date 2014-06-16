module B2W
  class Product < Base
    def self.create!(params)
      post(:product, params) do |body, request, result|
        new persisted: result.is_a?(Net::HTTPCreated)
      end
    end

    def update_price!
      put(:sku, "#{sku}/price", sellPrice: self['sell_price'], listPrice: self['list_price'])
    end

    def exists?
      begin
        self.class.get "sku/#{sku}"
        true
      rescue RestClient::ResourceNotFound 
        false
      end
    end

    private

    def sku
      self['sku']
    end
  end
end
