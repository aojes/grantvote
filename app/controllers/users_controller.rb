class UsersController < ApplicationController
  # require user for private production
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :verify_authenticity_token

  def new
    @page_title = "Welcome to Grantvote"
    # @user = User.new
    @user = User.new#(:invitation_token => params[:invitation_token])
    #@user.email = @user.invitation.email if @user.invitation
  end

  def create
    @user = User.new(params[:user])
    @user.build_profile(:user => @user)
    @user.build_credit(:user => @user, :pebbles => 1)
    if @user.save
      flash[:notice] = "Account created. Welcome! "
      redirect_to profile_path(@user)
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

    new_password = params[:user][:new_password]
    confirmation = params[:user][:confirm_new_password]
    if !new_password.blank? and new_password == confirmation
      if @user.valid_password?(params[:user][:current_password])
        @user.password = new_password
        @user.password_confirmation = new_password
      end
    end

    email = params[:user][:email]
    login = params[:user][:login]

    new_email = email != @user.email
    new_login = login != @user.login

    if new_email or new_login
      if @user.valid_password?(params[:user][:password_confirm_vital])
        if @user.update_attributes(params[:user])
          if @user.profile.update_attributes(:login => @user.login, :permalink => @user.login)
            flash[:notice] = "Updated profile."

            redirect_to profile_path(@user.profile.login)
          end
        else
          render :action => :edit
        end
      else
        render :action => :edit
      end
    elsif @user.update_attributes(params[:user])
      flash[:notice] = "Updated profile. "

      redirect_to profile_path(@user.login)
    else
      render :action => :edit
    end
  end
end

