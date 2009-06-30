# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_anisette_session',
  :secret      => '5f2631435eaa8b929480d3fc2f49e8c8d268b8f347753c98aba5177c5d264bbab52e97b17b999288de7c36438a4dde51c48447c29bd9c7d119d081ba5bba1c33'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
