Hirviurheilu::Application.config.session_store :active_record_store
ActiveRecord::SessionStore::Session.table_name = 'user_sessions'
