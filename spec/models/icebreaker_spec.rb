require File.dirname(__FILE__) + '/../spec_helper'

describe Icebreaker do
  it "should be valid" do
    Icebreaker.new.should be_valid
  end
end
