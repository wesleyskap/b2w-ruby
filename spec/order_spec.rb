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
        "{}"
      end
      B2W::Order.approved
    end
  end
end
