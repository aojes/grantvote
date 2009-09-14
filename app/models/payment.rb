class Payment < ActiveRecord::Base

  belongs_to :user
  has_many :transactions, :class_name => "PaymentTransaction"

  AMOUNT = 5.00
  DIVIDEND = 5.00

  attr_protected :user_id, :group_id, :amount, :success, 
                 :caller_token_id, :recipient_token_id, :pipeline_token_id,
                 :created_at, :updated_at

  ##
  # typical response params (for payment on Amazon with credit card)
  #
  #{"tokenID"=>"---------------------------------",
  # "callerReference"=>"37-payment-1234567890",  # Payment id (first figure)
  # "awsSignature"=>"bwyMOG28eBur1LxA9dqh32TdODs=",
  # "expiry"=>"01/2015",
  # "status"=>"SC"}


  def process_payment! # FIXME handle failed updates when payment succeeds
    transaction do 
      if group_id.zero? # Blitz payment
        
        user.blitz_interest = true
        user.points += 1
        user.blitz_contributes += DIVIDEND
        
        user.credit.points  += 1
        user.credit.pebbles += 1
        

        blitz_fund = BlitzFund.find_or_create_by_dues(DIVIDEND)
        blitz_fund.general_pool += DIVIDEND

        self.success = true
        self.updated_at = Time.now

        (user.save && user.credit.save && blitz_fund.save && self.save) or 
          raise ActiveRecord::Rollback

      else
        membership = Membership.find_by_user_id_and_group_id(user, group_id)
        if membership.nil?

          user.points += 1
          
          user.credit.points  += 1
          user.credit.pebbles += 1
          
          group = Group.find(group_id)
          group.funds += DIVIDEND
          group.memberships.build(
            :user_id     => user_id,
            :group_id    => group_id,
            :interest    => true,
            :contributes => DIVIDEND,
            :rewards     => 0
          )

          self.success = true
          self.updated_at = Time.now          

          (user.save && user.credit.save && group.save && self.save) or 
            raise ActiveRecord::Rollback

        else
          membership.interest = true
          membership.contributes += DIVIDEND
          
          membership.group.funds += DIVIDEND
          
          membership.user.points += 1
          
          membership.user.credit.points  += 1
          membership.user.credit.pebbles += 1

          self.success = true
          self.updated_at = Time.now
                
          (membership.save && membership.group.save && 
             membership.user.save && self.save) or raise ActiveRecord::Rollback
        end
      end
    end
  end

end

