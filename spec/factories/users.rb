Factory.define :user, :class => User do |u|
  u.login "foo"
  u.password "pass"
  u.password_confirmation "pass"
  u.email "foo@example.com"
end

Factory.define :invalid_user, :class => User do |u|
end
