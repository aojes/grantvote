class PaymentsController < ApplicationController
  
  before_filter :require_user
  before_filter :verify_authenticity_token

  def new
    @payment = Payment.new
    @payment.user_id = current_user
    @payment.group_id = session[:group_id]
    
    request = Remit::InstallPaymentInstruction::Request.new(  
      :payment_instruction => "MyRole == 'Caller' orSay 'Role does not match';",  
      :caller_reference => Time.now.to_i.to_s,  
      :token_friendly_name => "Grantvote Caller Token",  
      :token_type => "SingleUse"  
    )  
      
    install_caller_response = remit.install_payment_instruction(request)  
    @payment.caller_token_id = install_caller_response.token_id 

    request = Remit::InstallPaymentInstruction::Request.new(  
      :payment_instruction => "MyRole == 'Recipient' orSay 'Role does not match';",   
      :caller_reference => Time.now.to_i.to_s,  
      :token_friendly_name => "Grantvote Payment Receipt",  
      :token_type => "SingleUse"  
    )  

    install_recipient_response = remit.install_payment_instruction(request) 
    @payment.recipient_token_id = install_recipient_response.token_id
    
    if @payment.save
      redirect_to remit.get_single_use_pipeline({
        :caller_reference   => "#{@payment.id}-payment-#{Time.now.to_i}",
        :recipient_token    => @payment.recipient_token_id,
        :payment_reason     => "Blitz Writing and Voting Privileges",
        :transaction_amount => '3.00',
        :return_url         => 'http://localhost:3000/payments/finalize'
      }).url
    else
      redirect_back_or_default :back
    end
  end

    
  
  ##
  # Check, validate, and store the sender token to capture the payment, or
  # charge the transaction immediately. Think of the sender token as being
  # similar to a credit card authorization.
  #
  def finalize
    #
    #
    #
    # if response.successful? # response.valid? && response.successful?
     
      # store the sender token to use it later, or just use immediately to
      # charge the transaction as follows:
      # pipeline_response = Remit::PipelineResponse.new(url, "my secret key")       
    
    payment_id = params[:callerReference].split('-').first.to_i
    @payment = Payment.find(payment_id)
    if @payment
    
      @payment.pipeline_token_id = params[:tokenID]

      if @payment.save      
              
        request = returning Remit::Pay::Request.new do |r|
          r.sender_token_id = params[:tokenID]
          r.caller_token_id = @payment.caller_token_id
          r.recipient_token_id = @payment.recipient_token_id
          r.transaction_amount = Remit::RequestTypes::Amount.new(
                                       :currency_code => 'USD', :amount => 3.00)
          r.charge_fee_to = 'Recipient' # Remit::ChargeFeeTo::RECIPIENT
          r.caller_reference = "#{@payment.id}-transaction-#{Time.now.to_i}"
          r.meta_data = "Blitz Writing and Voting Privileges"
        end
      
        payment_response = remit.pay(request)
      end
            
      if payment_response.successful?
        flash[:notice] = "Success!"
        redirect_to blitzes_path
      else
        flash[:notice] = "Unsuccessful."
        redirect_to blitzes_path
      end
    end
  end
  
private

  def remit
    @sandbox ||= !Rails.env.production?
    @remit ||= Remit::API.new(FPS_ACCESS_KEY, FPS_SECRET_KEY, @sandbox)
  end 
end  
# PAYPAL
#   ssl_required :express, :new, :create if Rails.env.production?
##  
#  def express
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
#  end

#  def new
##  # PAYPAL
#    @page_title = "Express Payment"
#    @payment = Payment.new(:express_token => params[:token])
#    unless session[:group_permalink] == 0
#      @group = Group.find_by_permalink(session[:group_permalink])
#    end
#  end

#  def create
#  # PAYPAL
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
#  end
#end  
