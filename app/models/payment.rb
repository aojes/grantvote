class Payment < ActiveRecord::Base
  
  belongs_to :user
  has_many :transactions, :class_name => "PaymentTransaction"
  
  AMOUNT = 3
  DIVIDEND = AMOUNT - 1
  AMOUNT_STR = sprintf("%.2f", AMOUNT.to_f.round(2))
 
  # attr_accessor :card_number, :card_verification
  
  # validates_presence_of :amount, :full_name, :address_line_1, :city, :state
  # validates_presence_of :country, :zipcode
  
  # validates_numericality_of :amount, :greater_than_or_equal_to => AMOUNT, 
  #  :message => "can be greater than or equal to $#{AMOUNT}"  
  
  # validate_on_create :validate_card

  def process_payment
    #    response = process_purchase
    #    transactions.create!(:action => "purchase", 
    #                         :amount => price_in_cents, 
    #                         :response => response)
    #    status = response.success?
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
#  
#  def express_token=(token)
#    write_attribute(:express_token, token)
#    if new_record? && !token.blank?
#      details = EXPRESS_GATEWAY.details_for(token)
#      self.express_payer_id = details.payer_id
#      self.first_name = details.params["first_name"]
#      self.last_name = details.params["last_name"]
#    end
#  end
#  
#  def price_in_cents    
#    (amount * 100).round
#  end

#  private

#  def process_purchase
#    if express_token.blank?
#      STANDARD_GATEWAY.purchase(price_in_cents, credit_card, standard_purchase_options)
#    else
#      EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
#    end
#  end

#  def standard_purchase_options
#    {
#      :ip => ip_address,
#      :billing_address => {
#        :name     => full_name,
#        :address1 => address_line_1,
#        :address2 => address_line_2,
#        :city     => city,
#        :state    => state,
#        :country  => country,
#        :zip      => zipcode
#      }
#    }
#  end

#  def express_purchase_options
#    {

#      :amount => 5,
#      :ip => ip_address,
#      :token => express_token,
#      :payer_id => express_payer_id
#    }
#  end

#  def validate_card
#    if express_token.blank? && !credit_card.valid?
#      credit_card.errors.full_messages.each do |message|
#        errors.add_to_base message
#      end
#    end
#  end
#  
#  def credit_card
#    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
#      :type               => card_type,
#      :number             => card_number,
#      :verification_value => card_verification,
#      :month              => card_expires_on.month,
#      :year               => card_expires_on.year,
#      :first_name         => first_name,
#      :last_name          => last_name
#    )
#  end
  
end
