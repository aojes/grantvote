class Payment < ActiveRecord::Base
  
  belongs_to :user
  has_many :transactions, :class_name => "PaymentTransaction"
  
  AMOUNT = 3
  DIVIDEND = AMOUNT - 1

  ##
  # typical response params (for payment on Amazon with credit card)
  #
  #{"tokenID"=>"---------------------------------",
  # "callerReference"=>"37-payment-1234567890",  # Payment id (first figure)
  # "awsSignature"=>"bwyMOG28eBur1LxA9dqh32TdODs=",
  # "expiry"=>"01/2015",
  # "status"=>"SC"}
 

  def process_payment # FIXME handle failed updates when payment succeeds
    status = update_attribute(:success, true)
    if status 
      transaction do
        if group_id.zero? # Blitz
  
          user.update_attributes!(:blitz_interest => true, 
            :points => user.points + 1, 
            :blitz_contributes => user.blitz_contributes + AMOUNT
          )
          user.credit.update_attributes!(
            :points  => ( user.credit.points  + 1),
            :pebbles => ( user.credit.pebbles + 1) 
          )
          
          blitz_fund = BlitzFund.find_or_create_by_dues(AMOUNT)
          blitz_fund.update_attributes!(
            :general_pool => blitz_fund.general_pool + DIVIDEND)
  
        else
          membership = Membership.find_by_user_id_and_group_id(user, group_id)
          if membership.nil?
            user.memberships.create!(
              :group_id    => group_id, 
              :interest    => true, 
              :contributes => AMOUNT, 
              :rewards     => 0
            )
            user.update_attributes!(:points => user.points + 1)
            user.credit.update_attributes!(
              :points  => ( user.credit.points  + 1),
              :pebbles => ( user.credit.pebbles + 1) 
            )
            
            group = Group.find(group_id)
            group.update_attributes!(:funds => group.funds + DIVIDEND)
          else
            membership.update_attributes!(
              :interest    => true,
              :contributes => membership.contributes + AMOUNT
            )
            membership.group.update_attributes!(
              :funds => membership.group.funds + DIVIDEND
            )
            membership.user.update_attributes!(
              :points => membership.user.points + 1
            )
            membership.user.credit.update_attributes!(
              :points  => ( user.credit.points  + 1),
              :pebbles => ( user.credit.pebbles + 1)
            )
          end
        end
        update_attribute(:updated_at, Time.now)
      end
    end

    status
  end

end
