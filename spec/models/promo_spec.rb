require File.dirname(__FILE__) + '/../spec_helper'

describe Promo do
  it "should be valid" do
    Promo.new.should be_valid
  end
end
