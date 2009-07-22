require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupsController do
  #integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
      @group = Factory(:group)
      @group.memberships.create(:user => @user)
    end
    describe "shouble be authenticated" do
      it "should fail if we are not authenticated" do
        controller.should_receive(:index)
        get :index
        response.should be_success
        @group.memberships.first.user.should == @user
      end
    end
  end
  
  describe "Logged out examples" do
    describe "should not be authenticated" do
      it "should pass if we are not authenticated" do
        controller.should_not_receive(:index)
        get :index
        response.should_not be_success
      end
    end
  end
  
end
