module B2W
  class Batch < Base
    def self.stock(params)
      post("#{path}/stock", params)
    end

    private

    def self.path
      "/batch/sku"
    end
  end
end
