When /^I write a grant$/ do
  @grant = Grant.new(:group => @group, :user => @user, :name => "grant", 
    :amount => 10, :proposal => "proposal", :photo_file_name => "photo.png", 
    :photo_content_type => "image/png", :photo_file_size => 1,
    :final => false, :awarded => false)
  @grant.save.should == true
end

Then /^I vote the grant into session$/ do

  @grant.votes.create!(:user => @user, :group => @group, :cast => "yea")
  @grant.votes.yea.count.should == 1
end

Then /^I write another grant$/ do
  @new_grant = Grant.new(:group => @group, :user => @user, :name => "new grant", 
    :amount => 10, :proposal => "new proposal", :photo_file_name => "photo.png", 
    :photo_content_type => "image/png", :photo_file_size => 1,
    :final => false, :awarded => false)
  @new_grant.save.should == true
end

Then /^I am not allowed to vote it into session$/ do
  @new_grant.votes << Vote.new(:user => @user, :group => @group, 
                  :grant => @new_grant, :cast => "yea")
  @new_grant.save.should == false
  
  # ???
  
end

