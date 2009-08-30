Given /^my blitz interest is (.+)$/ do |interest|
#  @user = User.find_by_login("foo")

  @user.should be_true

  @user.blitz_interest.to_s.should == interest
end

Given /^my blitz contributions equal (.+)$/ do |contributes|
  @user.blitz_contributes.should == contributes.to_i
end

Given /^my blitz rewards equal (.+)$/ do |rewards|
  @user.blitz_rewards.should == rewards.to_i
end

When /^I make a payment of (.+)$/ do |payment|
  @payment = @user.payments.create!(
    :group_id => 0,
    :amount => payment.to_i,
    :success => false
  )
  @payment.process_payment!
end

Then /^I should have a blitz interest of (.+)$/ do |blitz_interest|
  # Baffled... FIXME
  @user.blitz_interest.to_s.should == blitz_interest
end

Then /^I should have a new total blitz contribution of (.+)$/ do |new_total|
  @user.blitz_rewards.should == new_total.to_i
end

