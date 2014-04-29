require 'spec_helper'

describe B2W::Product do
  describe ".create!" do
    it "should persist a valid product" do
      product = VCR.use_cassette('product_success') do
        B2W::Product.create!(id: 'b2w-ruby-1', name: 'B2W Ruby', sku: [{ id: 'b2w-ruby-1', name: 'B2W Ruby', ean: ['1234567890128'], weight: 1, stockQuantity: 3, enable: true, price: { sellPrice: 10, listPrice: 10 }}], manufacturer: { name: 'Digital Pages', model: 'b2w-ruby', warrantyTime: 1 }, deliveryType: 'SHIPMENT', nbm: { number: '49019900', origin: '1' })
      end
      product.should be_persisted
    end

    it "should not persist an invalid product" do
      product = VCR.use_cassette('product_not_success') do
        B2W::Product.create!(id: 'b2w-ruby-2', name: 'B2W Ruby', sku: [{ id: 'b2w-ruby-2', name: 'B2W Ruby', ean: ['invalid'], weight: 1, stockQuantity: 3, enable: true, price: { sellPrice: 10, listPrice: 10 }}], manufacturer: { name: 'Digital Pages', model: 'b2w-ruby', warrantyTime: 1 }, deliveryType: 'SHIPMENT', nbm: { number: '49019900', origin: '1' })
      end
      product.should_not be_persisted
    end
  end
end
