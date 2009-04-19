When /^I find an interesting group$/ do
  @group = Group.create!(:id => 1, :name => "ab", :purpose => "abc", :dues => 2,
      :funds => 200,
      :photo_file_name => "photo.jpg",:photo_file_size => Group::MAX_FILE_SIZE,
      :photo_content_type => 'image/jpeg')
end

Then /^I join without paying dues$/ do
  @group.memberships << Membership.new(:user_id => 1, :group_id => 1, 
   :interest => false, :created_at => 1.minute.ago, :updated_at => 1.minute.ago)
  @group.save.should == true
end

Then /^I am a member without voting interest$/ do
  @group.memberships.count.should == 1
  @group.memberships.first.interest.should == false
end

