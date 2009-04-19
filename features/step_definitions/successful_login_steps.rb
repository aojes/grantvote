Before('@login') do
  # This will only run before scenarios tagged above

  @user = User.create!(:login => "foo", :email => "foo@grantvote.com",
                    :password => "secret", :password_confirmation => "secret")
  visit path_to("/the homepage/i")
  fill_in('Login', :with => @user.login)
  fill_in('Password', :with => @user.password)
  click_button("Login")

end

Given /^I am a logged in user$/ do
end


