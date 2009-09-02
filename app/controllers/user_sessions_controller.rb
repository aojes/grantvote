class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  before_filter :verify_authenticity_token

 def index
  redirect_to root_url
 end

  def new
    @page_title = "Welcome to Grantvote"
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "You have logged in."
      redirect_back_or_default home_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "You have logged out."
    redirect_back_or_default login_path

  end
end

