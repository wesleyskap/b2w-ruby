module B2W
  class Order < Base
    def self.all(params = {})
      get(:order, params)
    end

    def self.approved(params = {})
      all({ status: 'APPROVED' }.merge(params))
    end

    def processing!
      put(:order, "#{self['id']}/status", '{"status": "PROCESSING"}')
    end
  end
end
