Before('@login') do
  # This will only run before scenarios tagged above

  @user = User.create!(:login => "foobar", :email => "foobar@grantvote.com",
                    :password => "secret", :password_confirmation => "secret")
  @user.create_profile(:user => @user, :login => @user.login)
  visit path_to("/the homepage/i")
  fill_in('Login', :with => @user.login)
  fill_in('Password', :with => @user.password)
  click_button("Login")
  response.request.path.should == path_to("/the account page/i")

end

Before('@group') do
  @group = Group.create!(:name => "foobar", :purpose => "foobar", :dues => 2,
                    :photo_file_size => 1, :photo_content_type => 'image/png', 
                    :photo_file_name => "photo.png")
end

Before('@voter') do
  @group = Group.create!(:name => "foobar", :purpose => "foobar", :dues => 2,
                    :photo_file_size => 1, :photo_content_type => 'image/png', 
                    :photo_file_name => "photo.png")
  @group.memberships.create!(:user => @user, :interest => true)
end 

Before('@grant') do
  @group.grants.create!(:user => @user, :name => "foobar", :amount => 20, 
  :proposal => "foobar", :photo_file_size => 1, 
      :photo_content_type => 'image/png', :photo_file_name => "photo.png")
end
