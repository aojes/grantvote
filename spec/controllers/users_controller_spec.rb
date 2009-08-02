require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  #integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
    end
    describe "should be authenticated" do
      it "should fail if we are not authenticated" do
      end
    end
  end
  
  describe "Logged out examples" do
    describe "should not be authenticated" do
      it "should pass if we are not authenticated" do
      end
    end
  end
  
end
