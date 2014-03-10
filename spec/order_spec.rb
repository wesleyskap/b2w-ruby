require 'spec_helper'

describe B2W::Order do
  describe ".all" do
    it "returns the orders details" do
      B2W::Order.all.first["id"].should == "65"
    end
  end
end
