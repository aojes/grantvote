class PaymentsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def express
    group_id = session[:group_permalink] == 0 ?
          0 : Group.find_by_permalink(session[:group_permalink]).id 
    response = EXPRESS_GATEWAY.setup_purchase( (Payment::MIN_PAY * 100),
      :user_id           => current_user.id,
      :group_id          => group_id,
      :ip                => request.remote_ip,
      :return_url        => new_payment_url,
      :cancel_return_url => group_id.zero? ? blitzes_url : groups_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    @page_title = "Express Payment"
    @payment = Payment.new(:express_token => params[:token])
    unless session[:group_permalink] == 0
      @group = Group.find_by_permalink(session[:group_permalink])
    end
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment.user_id = current_user.id
    @payment.group_id = session[:group_permalink] == 0 ? 
                    0 : Group.find_by_permalink(session[:group_permalink]).id
    @payment.amount = Payment::MIN_PAY
    @group = @payment.group_id.zero? ?
                    false : Group.find_by_permalink(session[:group_permalink])
    @payment.ip_address = request.remote_ip
    if @payment.save
      if @payment.purchase
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render 'new' 
    end
  end
  
end
