module B2W
  class Order
    def self.all(params = {})
      B2W.get(:order, params)
    end

    def self.approved(params = {})
      all({ status: 'APPROVED' }.merge(params))
    end
  end
end
