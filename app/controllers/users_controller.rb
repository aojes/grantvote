class UsersController < ApplicationController
  # require user for private production
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user#, :only => [:show, :edit, :update]
  before_filter :verify_authenticity_token

  def new
    @page_title = "Welcome to Grantvote"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.build_profile(:user => @user)
    @user.build_credit(:user => @user, :pebbles => 1)
    if @user.save
      flash[:notice] = "Account created. "
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    @page_title = "Your Account"  
    @user = @current_user
  end

  def edit
    @page_title = "Edit Account"  
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
   
    if @user.update_attributes(params[:user])
      flash[:notice] = "Updated profile. "

      redirect_to profile_path(@user.login)
    else
      render :action => :edit
    end
  end
end

