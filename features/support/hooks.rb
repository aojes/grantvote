Before('@login') do
  # This will only run before scenarios tagged above
  
      Invitation.create(:id=>'1', :email=>'foo@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'1', :login => "foo", :email => "foo@grantvote.com", :points => 0,
        :password => "pass", :password_confirmation => "pass", :invitation_id=>'1', :invitation_limit=>'5',
        :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
     
      Profile.create!(:user_id => 1, :login => "foo")
      Credit.create!(:user_id => 1, :points => 0)  

  visit '/login'
  fill_in('Username', :with => "foo")
  fill_in('Password', :with => "pass")
  click_button
  
  @user = User.find_by_login("foo")
  #response.request.path.should == path_to("/the homepage/i")

end

Before('@group') do
  @group = Group.create!(:name => "group", :purpose => "group purpose", 
                    :dues => 3,
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
