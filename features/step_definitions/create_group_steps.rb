Given /^I am logged in$/ do
   user = User.make
   @controller.stub!(:current_user).and_return(user)
end

When /^I create a new group$/ do
  @group = Group.new
end


Then /^I enter a name, purpose, dues, and photo$/ do
  @group.name = "n" * Group::MAX_NAME
  @group.purpose = "p" * Group::MAX_PURPOSE
  @group.dues = Group::MIN_DUES
  @group.photo_file_name = "photo.jpg"
  @group.photo_file_size = Group::MAX_FILE_SIZE
  @group.photo_content_type = 'image/jpeg'
end

Then /^they must validate$/ do
  @group.save.should == true
end

