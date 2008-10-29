require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Ad do
  
  before(:each) do
    Ad.all.destroy!
    @ad = Ad.new(:text => 'Buy Something!')
  end
  
  it "should validate presence of text" do
    @ad.should be_valid
    @ad.text = nil
    @ad.should_not be_valid
  end
  
  it "should validate the length of text to be within 0 and 140"
end