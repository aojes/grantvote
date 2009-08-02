class PaymentsController < ApplicationController
  
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  ssl_required :express, :new, :create if Rails.env.production?
  
  def express
    # FIXME
    request = Remit::InstallPaymentInstruction::Request.new(  
      :payment_instruction => 'Recipient',  
      :caller_reference => Time.now.to_i.to_s,  
      :token_friendly_name => 'Grantvote caller token',  
      :token_type => 'SingleUse'
    )  
     
    install_caller_response = remit.install_payment_instruction(request)  
    install_caller_response.token_id  # hold on to this 
    
    # FIXME use SingleUse pipeline
    recurring_use_pipeline = remit.get_recurring_use_pipeline(  
      :caller_reference => Time.now.to_i.to_s,  
      :recipient_token => install_recipient_response.token_id,  
      :transaction_amount => Payment::AMOUNT,  
      :recurring_period => "1 Month",  
      :return_URL => return_url,  
      :caller_key => config[:access_key]  
    )  
      
    recurring_use_pipeline.url      # this is the URL you want to send your users to         
  # PAYPAL
#    group_id = session[:group_permalink] == 0 ?
#          0 : Group.find_by_permalink(session[:group_permalink]).id 
#    response = EXPRESS_GATEWAY.setup_purchase( (Payment::MIN_PAY * 100),
#      :user_id           => current_user.id,
#      :group_id          => group_id,
#      :ip                => request.remote_ip,
#      :return_url        => new_payment_url,
#      :cancel_return_url => group_id.zero? ? blitzes_url : groups_url
#    )
#    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
  # PAYPAL
#    @page_title = "Express Payment"
#    @payment = Payment.new(:express_token => params[:token])
#    unless session[:group_permalink] == 0
#      @group = Group.find_by_permalink(session[:group_permalink])
#    end
  end

  def create
  # REMIT
#    request = Remit::InstallPaymentInstruction::Request.new(  
#      :payment_instruction => "MyRole == 'Recipient' orSay 'Role does not match';",  
#      :caller_reference => Time.now.to_i.to_s,  
#      :token_friendly_name => "Grantvote receiver token",  
#      :token_type => "Unrestricted"  
#    )  
#      
#    install_recipient_response = remit.install_payment_instruction(request)  
#    install_recipient_response.token_id  # hold on to this  
     
  
  # PAYPAL
#    @payment = Payment.new(params[:payment])
#    @payment.user_id = current_user.id
#    @payment.group_id = session[:group_permalink] == 0 ? 
#                    0 : Group.find_by_permalink(session[:group_permalink]).id
#    @payment.amount = Payment::MIN_PAY
#    @group = @payment.group_id.zero? ?
#                    false : Group.find_by_permalink(session[:group_permalink])
#    @payment.ip_address = request.remote_ip
#    if @payment.save
#      if @payment.purchase
#        render :action => "success"
#      else
#        render :action => "failure"
#      end
#    else
#      render 'new' 
#    end
  end
  
end
