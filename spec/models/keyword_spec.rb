require File.join( File.dirname(__FILE__), '..', "spec_helper" )

def validate_length_of(attribute, options)
  if options.has_key? :within
    min = options[:within].first
    max = options[:within].last
  end
  
  return simple_matcher("validate the length of #{attribute} to be within #{min || 0} and #{max || 'Infinity'}") do |model|
    invalid = false
    
    if !min.nil? && min >= 1
      model.send("#{attribute}=", 'a' * (min - 1))
      invalid = !model.valid? && !model.errors.on(attribute).nil?
    end
    
    if !max.nil?
      model.send("#{attribute}=", 'a' * (max + 1))
      invalid ||= !model.valid? && !model.errors.on(attribute).nil?
    end
    
    invalid
  end
end

def validate_uniqueness_of(attribute)
  return simple_matcher("validate the uniqueness of #{attribute}") do |model|
    model.class.stub!(:find).and_return(true)
    !model.valid? && model.errors.invalid?(attribute)
  end
end

describe Keyword do

  before(:each) do
    Keyword.all.destroy!
    @keyword = Keyword.new(:word => 'test')
  end

  it "should validate presence of word" do
    @keyword.should be_valid
    @keyword.word = nil
    @keyword.should_not be_valid
  end
  
  it do
    @keyword.should validate_length_of(:word, :within => 3..30)
  end
  
  it "should validate that word is unique" do
    @keyword.should be_valid
    @keyword.save
    @keyword = Keyword.new(:word => Keyword.first.word)
    @keyword.should_not be_valid
  end

end