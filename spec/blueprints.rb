require 'faker'
require 'populator'

Sham.login   { "foo" }
Sham.password { "foobar" }
Sham.password_confirmation { "foobar" }
Sham.email   { Faker::Internet.email }

Sham.name    { Faker::Name.name }
Sham.purpose { Populator.words(5..10) }
Sham.dues { 2 }

Sham.proposal { Populator.sentences(3..12) }

User.blueprint do
  login
  email
  password
  password_confirmation
end

Group.blueprint do
  name
  purpose
  dues
end
