# Be sure to restart your server when you modify this file.

#Drwho::Application.config.session_store :cookie_store, key: '_scholarship_session'
Drwho::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 120.minutes
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Scholarship::Application.config.session_store :active_record_store
