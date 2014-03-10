module B2W
  class Order
    def self.all
      B2W.get(:order)
    end
  end
end
