Factory.define :membership do |m|
  m.group { |g| g.association(:group) }
  m.user { |g| g.association(:user) }

  m.interest false # true for voting and writing privileges
  m.contributes 0
  m.rewards 0
end


