require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  # integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
    end
    
    describe "basic actions" do
      # TODO
    end
    
  end
  
  describe "Logged out examples" do
    it "should not allow any logged out actions" do
      controller.should_not_receive :index
      get :index
      controller.should_not_receive :new
      get :new
      controller.should_not_receive :create
      post :create
    end
  end
  
end
