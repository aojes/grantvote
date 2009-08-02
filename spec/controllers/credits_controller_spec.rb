require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CreditsController do
  #integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      activate_authlogic
      UserSession.create @user = Factory.build(:user)
    end
    describe "should be authenticated" do
      describe "basic actions" do
        it "should post #create" do
          post :create, :credit => {:user_id => @user.id, :points => 1}
          response.should be_success
        end
        
        # the update action is only used when the user gives a bead for a shell
        it "should put #update (corresponding to 'give bead' UI action)" do
           # FIXME
#          @user.credit.beads = 1
#          @user.credit.save
#          put :update, :credit => { :user_id => @user.credit.user_id, 
#                                    :beads   => 0,
#                                    :shells  => 1 }
#                                    
#          response.should redirect_to(:back)
        end
      end
    end
  end
  
  describe "Logged out examples" do
    it "should not allow any action" do
      controller.should_not_receive :create
      post :create
      controller.should_not_receive :update
      put :update
    end
  end
  
end
