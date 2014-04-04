require 'spec_helper'

describe B2W::Order do
  describe ".all" do
    it "returns the orders details" do
      VCR.use_cassette('orders') do
        B2W::Order.all.first["customer"]['pf']['cpf'].should == "11111111111"
      end
    end
  end
end
