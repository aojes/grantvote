Factory.define :user do |u|
  u.login "foo"
  u.password "pass"
  u.password_confirmation "pass"
  u.email "foo@example.com"
  
  u.association(:invitation, :factory => :invitation)
  
  u.association(:profile, :factory => :profile)
  
  u.association(:credit, :factory => :credit)
end

Factory.define :invalid_user, :class => User do |u|
end
