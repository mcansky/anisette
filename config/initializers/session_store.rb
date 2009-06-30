# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_anisette_session',
  :secret      => '8d86ef9ee0787f911cdcc2a5f10460dd88e50be8fd1f4d61654b31dd1ec887c9f457d461ca1d5bfe0461da1589749001e323a1565afdd06cfb0ba963babc6d48'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
