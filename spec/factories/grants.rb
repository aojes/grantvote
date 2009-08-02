Factory.define :grant do |g|
  g.name "grant name"
  g.proposal "grant proposal"
  g.amount 20
  
  g.association :membership
end

