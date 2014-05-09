module B2W
  class Product < Base
    def self.create!(params)
      post(:product, params) do |body, request, result|
        new persisted: result.is_a?(Net::HTTPCreated)
      end
    end

    def update_price!
      put(:sku, "#{self['sku']}/price", sellPrice: self['sell_price'], listPrice: self['list_price'])
    end
  end
end
