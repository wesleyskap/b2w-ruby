require 'spec_helper'

describe B2W::Order do
  describe ".all" do
    it "returns the orders details" do
      VCR.use_cassette('orders') do
        expect(B2W::Order.all.first["customer"]['pf']['cpf']).to eql "11111111111"
      end
    end
  end

  describe ".approved" do
    it "returns the approved orders details" do
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:url]).to include("status=APPROVED")
        '{"orders": []}'
      end
      B2W::Order.approved
    end

    it "accepts the purchase date" do
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:url]).to include("purchaseDate=2014-03-12")
        '{"orders": []}'
      end
      B2W::Order.approved(purchase_date: '2014-03-12')
    end
  end

  describe "#processing!" do
    it "should update the order status as processing" do
      orders = VCR.use_cassette('orders') { B2W::Order.all }
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:method]).to eql :put
        expect(params[:headers][:content_type]).to eql 'application/json'
        expect(params[:payload]).to eql '{"status":"PROCESSING"}'
        expect(params[:url]).to eql "https://api-marketplace.submarino.com.br/v1/order/67/status"
        ""
      end
      orders.first.processing!
    end
  end

  describe "#processing!" do
    it "should update the order status as processing" do
      orders = VCR.use_cassette('orders') { B2W::Order.all }
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:method]).to eql :put
        expect(params[:headers][:content_type]).to eql 'application/json'
        expect(params[:payload]).to eql '{"status":"PROCESSING"}'
        expect(params[:url]).to eql "https://api-marketplace.submarino.com.br/v1/order/67/status"
        ""
      end
      orders.first.processing!
    end
  end

  describe "#invoiced!" do
    it "should update the order status as invoiced" do
      orders = VCR.use_cassette('orders') { B2W::Order.all }
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:method]).to eql :put
        expect(params[:headers][:content_type]).to eql 'application/json'
        expect(params[:payload]).to eql "{\"status\":\"PROCESSING\",\"invoiced\":{\"key\":\"123\",\"number\":\"456\",\"line\":\"789\",\"issueDate\":\"2014-01-31\"}}"
        expect(params[:url]).to eql "https://api-marketplace.submarino.com.br/v1/order/67/status"
        ""
      end
      orders.first.invoiced! key: "123", number: "456", line: "789", issueDate: "2014-01-31"
    end
  end

  describe "#shipped!" do
    it "should update the order status as shipped" do
      orders = VCR.use_cassette('orders') { B2W::Order.all }
      expect(RestClient::Request).to receive(:execute) do |params|
        expect(params[:method]).to eql :put
        expect(params[:headers][:content_type]).to eql 'application/json'
        expect(params[:payload]).to eql "{\"status\":\"SHIPPED\",\"shipped\":{\"trackingProtocol\":\"123\",\"deliveredCarrierDate\":\"2013-12-31\",\"estimatedDelivery\":\"2014-01-31\"}}"
        expect(params[:url]).to eql "https://api-marketplace.submarino.com.br/v1/order/67/status"
        ""
      end
      orders.first.shipped! trackingProtocol: "123", deliveredCarrierDate: "2013-12-31", estimatedDelivery: "2014-01-31"
    end
  end
end
