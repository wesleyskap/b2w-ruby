require 'spec_helper'

describe B2W::Product do
  describe ".create!" do
    it "should persist a valid product" do
      product = VCR.use_cassette('product_success') do
        B2W::Product.create!(id: 'b2w-ruby-1', name: 'B2W Ruby', sku: [{ id: 'b2w-ruby-1', name: 'B2W Ruby', ean: ['1234567890128'], weight: 1, stockQuantity: 3, enable: true, price: { sellPrice: 10, listPrice: 10 }}], manufacturer: { name: 'Digital Pages', model: 'b2w-ruby', warrantyTime: 1 }, deliveryType: 'SHIPMENT', nbm: { number: '49019900', origin: '1' })
      end
      expect(product).to be_persisted
    end

    it "should not persist an invalid product" do
      product = VCR.use_cassette('product_not_success') do
        B2W::Product.create!(id: 'b2w-ruby-2', name: 'B2W Ruby', sku: [{ id: 'b2w-ruby-2', name: 'B2W Ruby', ean: ['invalid'], weight: 1, stockQuantity: 3, enable: true, price: { sellPrice: 10, listPrice: 10 }}], manufacturer: { name: 'Digital Pages', model: 'b2w-ruby', warrantyTime: 1 }, deliveryType: 'SHIPMENT', nbm: { number: '49019900', origin: '1' })
      end
      expect(product).to_not be_persisted
    end
  end

  describe "#update!" do
    it "should update a valid product" do
      product = B2W::Product.new 'sku' => 'b2w-ruby-1'
      VCR.use_cassette('product_update_true') do
        expect(product.update!(id: 'b2w-ruby-1', name: 'B2W Ruby', ean: ['1234567890128'], weight: 1, stockQuantity: 3, enable: true, price: { sellPrice: 10, listPrice: 10 })).to be true
      end
    end

    it "should not update an invalid product" do
      product = B2W::Product.new 'sku' => 'invalid'
      VCR.use_cassette('product_update_false') do
        expect(product.update!(id: 'b2w-ruby-1', name: 'B2W Ruby', ean: ['1234567890128'], weight: 1, stockQuantity: 3, enable: true, price: { sellPrice: 10, listPrice: 10 })).to be false
      end
    end
  end

  describe "#update_price!" do
    it "should update the prices" do
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:method]).to eql :put
        expect(params[:headers][:content_type]).to eql 'application/json'
        expect(params[:payload]).to eql '{"sellPrice":11.14,"listPrice":12.34}'
        expect(params[:url]).to eql "https://api-marketplace.submarino.com.br/v1/sku/b2w-ruby-1/price"
        ""
      end
      B2W::Product.new('sku' => 'b2w-ruby-1', 'sell_price' => 11.14, 'list_price' => 12.34).update_price!
    end
  end

  describe "#update_stock!" do
    it "should update the stock" do
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:method]).to eql :put
        expect(params[:headers][:content_type]).to eql 'application/json'
        expect(params[:payload]).to eql '{"quantity":2}'
        expect(params[:url]).to eql "https://api-marketplace.submarino.com.br/v1/sku/b2w-ruby-1/stock"
        ""
      end
      B2W::Product.new('sku' => 'b2w-ruby-1', 'quantity' => 2).update_stock!
    end
  end

  describe "#exists?" do
    it "should return true if the sku exists" do
      VCR.use_cassette('product_exists_true') do
        expect(B2W::Product.new('sku' => 'b2w-ruby-1').exists?).to be true
      end
    end

    it "should return false if the sku doesnt exists" do
      VCR.use_cassette('product_exists_false') do
        expect(B2W::Product.new('sku' => '0123').exists?).to be false
      end
    end
  end
end
