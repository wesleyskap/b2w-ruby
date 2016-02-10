module B2W
  class Batch < Base
    def self.stock(params)
      post("#{path}/stock", params)
    end

    def self.price(params)
      post("#{path}/stock", params)
    end

    def self.find(sku, type)
      get("#{path}/#{type}/#{sku}")
    end
    private

    def self.path
      "/batch/sku"
    end
  end
end
