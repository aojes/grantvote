require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlitzesController do
  #integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
      @blitz = Factory(:blitz)
    end
    
    describe "basic actions" do
      it "should get #index" do
        get :index
        response.should be_success
      end
      
      it "should get #new" do
        get :new
        response.should be_success
      end
      
      it "should post #create" do
        post :create, :blitz => {:name => "abc", 
                                 :proposal => "def", :amount => 10 }
        response.should redirect_to('/blitz/abc')
      end
      
      it "should get #edit and put #update" do
        get :edit, :id => @blitz.permalink
        response.should be_success
        put :update, :blitz => { :name     => "new name",
                                 :proposal => @blitz.proposal,
                                 :amount   => @blitz.amount    },
                     :id => @blitz.permalink
        response.should redirect_to('/blitz/new-name')
      end
      
      it "should get #show" do
        get :show, :id => @blitz.permalink
        response.should be_success
      end
    end    
  end
  
  describe "Logged out examples" do
    describe "should not be authenticated" do
      it "should fail any logged out action in private beta" do
        controller.should_not_receive :index
        get :index
        controller.should_not_receive :show
        get :show
        controller.should_not_receive :new
        get :new
        controller.should_not_receive :create
        post :create
        controller.should_not_receive :edit
        get :edit
        controller.should_not_receive :update
        put :update
      end
    end
  end
  
end
