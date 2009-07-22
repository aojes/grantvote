require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )

describe ProfilesController do
  integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
    end
    
    describe "should be authenticated" do
      it "should show the user's profile" do
        get :view, :permalink => @user.login
        response.should be_success
      end
    end
  end
  
  describe "Logged out examples" do
    it "should not show profiles to logged out users" do
      controller.should_not_receive(:show)
      get :view
      response.should redirect_to(root_path)
    end
  end
  
end
  
