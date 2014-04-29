module B2W
  class Product < Base
    def self.create!(params)
      post(:product, params) do |body, request, result|
        new persisted: result.is_a?(Net::HTTPCreated)
      end
    end
  end
end
