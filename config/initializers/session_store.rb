# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_marli_session', domain: ENV['LOGIN_COOKIE_DOMAIN'] #unless Rails.env.test?
