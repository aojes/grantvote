require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GrantsController do
  # integrate_views
  
  describe "Authenticated examples" do
    before(:each) do
      @grant = Factory(:grant)
      activate_authlogic
      UserSession.create @grant.user
    end
    describe "should be authenticated" do
      it "should get #index, #show, #new" do
        # FIXME test searchlogic
        # get :index
        # response.should be_success
        # FIXME go through routes (how?)
        # get :new
        # response.should be_success
        # FIXME broken
        # get :show, :id => @grant.permalink
        # response.should be_success

      end
    end
  end
  
  describe "Logged out examples" do
    describe "should not be authenticated" do
      it "should not allow any actions" do
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
        controller.should_not_receive :destroy
        delete :destroy
      end
    end
  end
  
end
