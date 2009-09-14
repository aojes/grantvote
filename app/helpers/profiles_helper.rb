module ProfilesHelper
  def can_exchange?(user)
    if user.credit.last_exchange_at.nil? && 
       current_user.credit.last_exchange_at.nil?
      true
    elsif current_user.credit.last_exchange_at.nil?
      user.credit.last_exchange_at < 24.hours.ago
    else
      user.credit.last_exchange_at < 24.hours.ago && 
      current_user.credit.last_exchange_at < 12.hours.ago
    end
  end

end
