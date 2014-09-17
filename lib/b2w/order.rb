module B2W
  class Order < Base
    def self.all(params = {})
      get(:order, params)["orders"].map { |params| new params }
    end

    def self.approved(params = {})
      all({ status: 'APPROVED' }.merge(params))
    end

    def processing!
      put(:order, "#{self['id']}/status", status: 'PROCESSING')
    end

    def invoiced!(body)
      put(:order, "#{self['id']}/status", status: 'PROCESSING', invoiced: body)
    end

    def shipped!(body)
      put(:order, "#{self['id']}/status", status: 'SHIPPED', shipped: body)
    end
  end
end
