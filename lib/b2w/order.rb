module B2W
  class Order < Base
    def self.all(params = {})
      get(:order, params)["orders"].map { |params| new params }
    end

    def self.find(id)
      get("order/#{id}")
    end

    def self.approved(params = {})
      all({ status: 'APPROVED' }.merge(params))
    end

    def processing!
      put(:order, "#{self['id']}/status", status: 'PROCESSING')
    end

    %w(invoiced shipped delivered).each do |status|
      define_method "#{status}!" do |body|
        put(:order, "#{self['id']}/status", status: status.upcase, status => body)
      end
    end
  end
end
