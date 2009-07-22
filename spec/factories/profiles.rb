Factory.define :profile, :class => Profile do |p|
  p.login "foo"
  p.permalink "foo" 
end

Factory.define :invalid_profile, :class => Profile do |u|
end
