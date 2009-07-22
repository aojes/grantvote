require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create Factory.build(:user)
    end
    describe "shouble be authenticated" do
      it "should fail if we are not authenticated" do
        get :show
        response.should be_success
      end
    end
  end
  describe "Logged out examples" do
    describe "shouble be authenticated" do
      it "should fail if we are not authenticated" do
        get :show
        response.should_not be_success
      end
    end
  end
end
