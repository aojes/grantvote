When /^I find an interesting group$/ do
  @user = User.create!(:login => "foo", :email => "foo@grantvote.com", 
    :password => "secret", :password_confirmation => "secret")
  @group = Group.create!(:name => "ab", :purpose => "abc", :dues => 2,
      :funds => 200,
      :photo_file_name => "photo.jpg",:photo_file_size => Group::MAX_FILE_SIZE,
      :photo_content_type => 'image/jpeg')
end

Then /^I join without paying dues$/ do
  @group.memberships << Membership.new(:user => @user,  :interest => false)
  @group.save.should == true
end

Then /^I am a member without voting interest$/ do
  @group.memberships.count.should == 1
  @group.memberships.first.interest.should == false

end

