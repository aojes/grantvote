class UsersController < ApplicationController
  # require user for private production
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :verify_authenticity_token

  def new
    @page_title = "Welcome to Grantvote"
    #@user = User.new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.email if @user.invitation
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
   
    new_email = params[:user][:email] != @user.email
    new_login = params[:user][:login] != @user.login
    
    if new_email or new_login       
      if @user.valid_password?(params[:user][:password_confirm_vital])
        if @user.update_attributes(params[:user])
          flash[:notice] = "Updated profile."
          redirect_to profile_path(@user.login)
        end
      else
        render :action => :edit
      end      
    elsif not new_email and not new_login
      if @user.update_attributes(params[:user])
        flash[:notice] = "Updated profile. "

        redirect_to profile_path(@user.login)
      end
    else
      render :action => :edit
    end
  end
end

