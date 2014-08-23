require 'spec_helper'

describe B2W::Order do
  describe ".all" do
    it "returns the orders details" do
      VCR.use_cassette('orders') do
        B2W::Order.all.first["customer"]['pf']['cpf'].should == "11111111111"
      end
    end
  end

  describe ".approved" do
    it "returns the approved orders details" do
      RestClient::Request.should_receive(:execute) do |params|
        params[:url].should include("status=APPROVED")
        '{"orders": []}'
      end
      B2W::Order.approved
    end

    it "accepts the purchase date" do
      RestClient::Request.should_receive(:execute) do |params|
        params[:url].should include("purchaseDate=2014-03-12")
        '{"orders": []}'
      end
      B2W::Order.approved(purchase_date: '2014-03-12')
    end
  end

  describe "#processing!" do
    it "should update the order status as processing" do
      orders = VCR.use_cassette('orders') { B2W::Order.all }
      RestClient::Request.should_receive(:execute) do |params|
        params[:method].should == :put
        params[:headers][:content_type].should == 'application/json'
        params[:payload].should == '{"status":"PROCESSING"}'
        params[:url].should == "https://api-marketplace.submarino.com.br/v1/order/67/status"
        ""
      end
      orders.first.processing!
    end
  end
end
