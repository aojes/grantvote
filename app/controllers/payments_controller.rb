class PaymentsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def express
    response = EXPRESS_GATEWAY.setup_purchase( (Payment::MIN_PAY * 100),
      :ip                => request.remote_ip,
      :return_url        => new_payment_url,
      :cancel_return_url => groups_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    @page_title = "Express Payment"
    @payment = Payment.new(:express_token => params[:token])
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment.user_id = current_user.id
    unless params[:payment][:group_id]
      @payment.group_id = Group.find_by_permalink(session[:group_permalink]).id
      @payment.amount = Payment::MIN_PAY
    end
    @payment.ip_address = request.remote_ip
    if @payment.save
      if @payment.purchase
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render 'memberships/new' 
    end
  end
  
end
