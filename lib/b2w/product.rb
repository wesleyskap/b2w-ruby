module B2W
  class Product < Base
    def self.create!(params)
      post(:product, params) do |body, request, result|
        new persisted: result.is_a?(Net::HTTPCreated)
      end
    end

    def update!(params)
      bool_operation { self.class.post "product/#{sku}/sku", params }
    end

    def update_price!
      put(:sku, "#{sku}/price", sellPrice: self['sell_price'], listPrice: self['list_price'])
    end

    def update_stock!
      put(:sku, "#{sku}/stock", quantity: self['quantity'])
    end

    def exists?
      bool_operation { self.class.get "sku/#{sku}" }
    end

    private

    def bool_operation
      begin
        yield
        true
      rescue RestClient::ResourceNotFound
        false
      rescue RestClient::UnprocessableEntity
        false
      end
    end

    def sku
      self['sku']
    end
  end
end
