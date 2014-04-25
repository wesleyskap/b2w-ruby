module B2W
  class Order
    def self.all(params = {})
      B2W.get(:order, params)
    end

    def self.approved
      all(status: 'APPROVED')
    end
  end
end
