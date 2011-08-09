# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SMS2FAX_session',
  :secret      => '6f46f60032b79ba7ca0bf6920fa018edea2c7cb0d346409ebd77589ba64bbb959ed3e9fcd4f9f183c03ad1242f2a70cc1e99afe34d42e97f10ac8a120538092d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
