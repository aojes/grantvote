# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_grantvote_session',
  :secret      => '8f5c4b532125355a0ca8dff981609a18ac1f398c775e9fd6a302d9db5b6968afcc9b1d4b745d4ea37d807bff0508de775e2abb48e5689c2a31a8920022a51c78'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
