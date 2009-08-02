require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FriendshipsController do
  #integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      request.env["HTTP_REFERER"] = "/"
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
    end
    describe "should be authenticated" do
      it "should post #create and delete #destroy" do
         # FIXME
#        post :create, :friend_id => 37
#        response.should be_success
      end
    end
  end
  
  describe "Logged out examples" do
    it "should not allow any action" do
      controller.should_not_receive :create
      post :create
      controller.should_not_receive :destroy
      delete :destroy
    end
  end

end
