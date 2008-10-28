require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a keyword exists" do
  Keyword.all.destroy!
  request(resource(:keywords), :method => "POST", 
    :params => { :keyword => { :word => 'test' }})
end

describe "resource(:keywords)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:keywords))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of keywords" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a keyword exists" do
    before(:each) do
      @response = request(resource(:keywords))
    end
    
    it "has a list of keywords" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Keyword.all.destroy!
      @response = request(resource(:keywords), :method => "POST", 
        :params => { :keyword => { :word => 'test' }})
    end
    
    it "redirects to resource(:keywords)" do
      @response.should redirect_to(resource(Keyword.first), :message => {:notice => "keyword was successfully created"})
    end
    
  end
end

describe "resource(@keyword)" do 
  describe "a successful DELETE", :given => "a keyword exists" do
     before(:each) do
       @response = request(resource(Keyword.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:keywords))
     end

   end
end

describe "resource(:keywords, :new)" do
  before(:each) do
    @response = request(resource(:keywords, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@keyword)", :given => "a keyword exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Keyword.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
    
end

