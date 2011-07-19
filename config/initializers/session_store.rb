# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nls_session',
  :secret      => 'a1d45fb606d136659f7901d76f0dc5429383611b5c5d2a06b8f3bd665876ae610a9fb7472f6e7c8201babf7105aaa9808e9100b7456a9415f20544087ebdb12c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
