Factory.define :user do |u|
  u.login "foo"
  u.password "pass"
  u.password_confirmation "pass"
  u.email "foo@example.com"
  
  u.association(:invitation, :factory => :invitation)
  
  u.association(:profile, :factory => :profile)
  
  u.association(:credit, :factory => :credit)
end

Factory.define :user_two, :class => User do |u|
  u.login "bar"
  u.password "pass"
  u.password_confirmation "pass"
  u.email "bar@example.com"
  
  u.association(:invitation_two, :factory => :invitation)
  
  u.association(:profile, :factory => :profile)
  
  u.association(:credit, :factory => :credit)
end

Factory.define :invalid_user, :class => User do |u|
end
