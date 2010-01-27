# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_finance_session',
  :secret      => '7b323819813b0dae42b33413fa56583082bbbd55af8a9799155bb22043009d2ab03f2bb54987f9e51747970c568c50105cb4b9564c6d14b434738c15c9b3ad66'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
