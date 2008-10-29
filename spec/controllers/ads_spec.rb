require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "AdNotFound", :shared => true do
  before do
    @mock_proxy.stub!(:first).and_return(nil)
  end

  it "should raise NotFound" do
    lambda {
      do_request
    }.should raise_error
  end
end

describe Ads, "controller" do
  
  before(:each) do
    @mock_proxy = mock("proxy")
    @mock_user = mock(User, :ads => @mock_proxy)
    @mock_session = mock("session", :user => @mock_user)
  end
  
  describe "GET index" do
    def do_request
      dispatch_to(Ads, :index) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it "should be successful" do
      do_request.should be_successful
    end

    it "should assign ads for the view" do
      ads = [mock(:ad), mock(:ad)]
      @mock_session.should_receive(:user).and_return(@mock_user)
      @mock_user.should_receive(:ads).and_return(ads)
      do_request.assigns(:ads).should == ads
    end
  end
  
  describe "GET show" do
    before do
      @ad = mock(:ad)
      @mock_proxy.stub!(:first).and_return(@ad)
    end

    def do_request
      dispatch_to(Ads, :show, :id => '1') do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it "should be successful" do
      do_request.should be_successful
    end

    it "should assign ad for the view" do
      @mock_session.should_receive(:user).and_return(@mock_user)
      @mock_user.should_receive(:ads).and_return(@mock_proxy)
      @mock_proxy.should_receive(:first).with(:id => '1').and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end
  end
  
  describe "GET show (with missing ad)" do
    def do_request
      dispatch_to(Ads, :show, :id => '1') do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it_should_behave_like 'AdNotFound'
  end
  
  describe "Get new" do
    before do
      @ad = mock(:ad)
      @mock_proxy.stub!(:build).and_return(@ad)
    end

    def do_request
      dispatch_to(Ads, :new) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it "should be successful" do
      do_request.should be_successful
    end

    it "should assign ad for view" do
      @mock_proxy.should_receive(:build).and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end
  end
  
  describe "POST create (with valid ad)" do
    before(:each) do
      Ad.all.destroy!
      @attrs = {'text' => 'Buy something!'}
      @ad = Ad.new(@attrs)
      @mock_proxy.stub!(:build).and_return(@ad)
    end
    
    def do_request
      dispatch_to(Ads, :create, :ad => @attrs) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:render)
      end
    end

    it "should assign new ad" do
      @mock_proxy.should_receive(:build).with(@attrs).and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end

    it "should save the ad" do
      @ad.should_receive(:save)
      do_request
    end

    it "should redirect" do
      do_request.should redirect_to(resource(@ad))
    end
  end
  
  describe "POST create (with invalid ad)" do
    before do
      Ad.all.destroy!
      @attrs = {'text' => ''}
      @ad = mock(Ad, :save => false)
      @mock_proxy.stub!(:build).and_return(@ad)
    end
    
    def do_request
      dispatch_to(Ads, :create, :ad => @attrs) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:render)
      end
    end

    it "should assign new ad" do
      @mock_proxy.should_receive(:build).with(@attrs).and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end

    it "should attempt to save the ad" do
      @ad.should_receive(:save).and_return(false)
      do_request
    end

    it "should be successful" do
      do_request.should be_successful
    end
  end
  
  describe "GET edit" do
    before do
      @ad = mock(:ad)
      @mock_proxy.stub!(:first).and_return(@ad)
    end

    def do_request
      dispatch_to(Ads, :edit, :id => '1') do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it "should be successful" do
      do_request.should be_successful
    end

    it "should assign ad for the view" do
      @mock_proxy.should_receive(:first).with(:id => '1').and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end
  end
  
  describe "GET edit (with missing ad)" do
    def do_request
      dispatch_to(Ads, :edit, :id => 1) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it_should_behave_like 'AdNotFound'
  end
  
  describe "PUT update (with valid ad)" do
    before(:each) do
      Ad.all.destroy!
      @ad = Ad.create(:text => 'Buy something!')
      @attrs = {'text' => 'Buy something new!'}
      @mock_proxy.stub!(:first).and_return(@ad)
    end

    def do_request
      dispatch_to(Ads, :update, :id => @ad.id, :ad => @attrs) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it "should assign ad" do
      @mock_proxy.should_receive(:first).with(:id => @ad.id.to_s).and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end

    it "should update the ad's attributes" do
      @ad.should_receive(:update_attributes).and_return(true)
      do_request
    end

    it "should redirect" do
      do_request.should redirect_to(resource(@ad))
    end
  end
  
  describe "PUT update (with invalid ad)" do
    before do
      @attrs = {'text' => ''}
      @ad = mock(:ad, :update_attributes => false)
      @mock_proxy.stub!(:first).and_return(@ad)
    end

    def do_request
      dispatch_to(Ads, :update, :id => 1, :ad => @attrs) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:display)
      end
    end

    it "should assign new ad" do
      @mock_proxy.should_receive(:first).with(:id => '1').and_return(@ad)
      do_request.assigns(:ad).should == @ad
    end

    it "should attempt to update the ad's attributes" do
      @ad.should_receive(:update_attributes).and_return(false)
      do_request
    end

    it "should be successful" do
      do_request.should be_successful
    end
  end
  
  describe "PUT update (with missing ad)" do    
    def do_request
      dispatch_to(Ads, :update, :id => 1) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:display)
      end
    end

    it_should_behave_like 'AdNotFound'
  end
  
  describe "DELETE destroy" do
    before do
      @ad = mock(:users, :destroy => true)
      @mock_proxy.stub!(:first).and_return(@ad)
    end

    def do_request
      dispatch_to(Ads, :destroy, :id => 1) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:session).and_return(@mock_session)
        controller.stub!(:render)
      end
    end

    it "should find the ad" do
      @mock_proxy.should_receive(:first).with(:id => '1').and_return(@ad)
      do_request
    end

    it "should destroy the ad" do
      @ad.should_receive(:destroy).and_return(true)
      do_request
    end

    it "should redirect" do
      do_request.should redirect_to(resource(:ads))
    end
  end
  
  describe "DELETE destroy (with missing ad)" do    
    def do_request
      dispatch_to(Ads, :destroy, :id => 1) do |controller|
        controller.stub!(:ensure_authenticated)
        controller.stub!(:render)
      end
    end

    it_should_behave_like 'AdNotFound'
  end
  
end
