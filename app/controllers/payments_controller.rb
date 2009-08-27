class PaymentsController < ApplicationController

  before_filter :require_user
  before_filter :verify_authenticity_token

  def new
    @payment = Payment.new
    @payment.user_id = current_user
    @payment.group_id = session[:group_id]
    @payment.amount = Payment::AMOUNT

    @remit = initialize_remit

    request = Remit::InstallPaymentInstruction::Request.new(
      :payment_instruction  => "MyRole == 'Caller' orSay 'Role does not match';",
      :caller_reference     => Time.now.to_i.to_s,
      :token_friendly_name  => "Grantvote Caller Token",
      :token_type           => "SingleUse"
    )

    install_caller_response  = @remit.install_payment_instruction(request)
    @payment.caller_token_id = install_caller_response.token_id

    request = Remit::InstallPaymentInstruction::Request.new(
      :payment_instruction  => "MyRole == 'Recipient' orSay 'Role does not match';",
      :caller_reference     => Time.now.to_i.to_s,
      :token_friendly_name  => "Grantvote Payment Receipt",
      :token_type           => "SingleUse"
    )

    install_recipient_response  = @remit.install_payment_instruction(request)
    @payment.recipient_token_id = install_recipient_response.token_id

    if @payment.save
      redirect_to @remit.get_single_use_pipeline({
        :caller_reference   => "#{@payment.id}-payment-#{Time.now.to_i}",
        :recipient_token    => @payment.recipient_token_id,
        :payment_reason     => "Blitz Writing and Voting Privileges",
        :transaction_amount => Payment::AMOUNT.to_s,
        :return_url         => "http://#{host}/payments/finalize"
      }).url
    else
      redirect_back_or_default :back
    end
  end

  def finalize

    pipeline_response = Remit::PipelineResponse.new(request.url, FPS_SECRET_KEY)
    if pipeline_response.valid? && pipeline_response.successful?

      payment_id = params[:callerReference].split('-').first.to_i
      @payment = Payment.find(payment_id)
      if @payment

        @payment.pipeline_token_id = params[:tokenID]

        if @payment.save

          request = returning Remit::Pay::Request.new do |r|
            r.sender_token_id    = params[:tokenID]
            r.caller_token_id    = @payment.caller_token_id
            r.recipient_token_id = @payment.recipient_token_id
            r.transaction_amount = Remit::RequestTypes::Amount.new(
                            :currency_code => 'USD', :amount => Payment::AMOUNT)
            r.charge_fee_to      = 'Recipient'
            r.caller_reference   = "#{@payment.id}-transaction-#{Time.now.to_i}"
            r.meta_data          = "Blitz Writing and Voting Privileges"
          end

          payment_response = initialize_remit.pay(request)
        end

        if payment_response.successful? && @payment.process_payment!
          flash[:notice] = "Success!"
          if @payment.group_id.zero?
            redirect_to blitzes_path
          else
            group = Group.find(@payment.group_id)
            redirect_to group_path(group)
          end
        else
          flash[:notice] = "Unsuccessful."
          if @payment.group_id.zero?
            redirect_to blitzes_path
          else
            group = Group.find(@payment.group_id)
            redirect_to group_path(group)
          end
        end
      end
    else
      # process unhandled payment
      flash[:warning] = 'Transaction failed.' +
                        'Please try again, or contact support.'
      redirect_to profile_path(current_user)
    end
  end

private

  def initialize_remit
    @sandbox = true # ||= !Rails.env.production?
    Remit::API.new(FPS_ACCESS_KEY, FPS_SECRET_KEY, @sandbox)
  end

  def host
    @host ||= Rails.env.production? ? "www.grantvote.com" : "localhost:3000"
  end

end

