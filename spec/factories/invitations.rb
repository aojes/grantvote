Factory.define :invitation do |i|
  i.email "foo@example.com"
  i.news false
  i.token Digest::SHA1.hexdigest([Time.now, rand].join)
  i.sender_id 37
end

Factory.define :invitation_two, :class => Invitation do |i|
  i.email "bar@example.com"
  i.news false
  i.token Digest::SHA1.hexdigest([Time.now, rand].join)
  i.sender_id 37
end

Factory.define :invalid_invitation, :class => Invitation do |i|
end
