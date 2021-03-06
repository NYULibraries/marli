Rails.application.routes.draw do
  scope "admin" do
    resources :application_details
    resources :users
    get "auth_settings" => "users#auth_types", as: "auth_settings"
    get "reset_submissions(/:id)" => "users#reset_submissions", as: "reset_submissions"
    get "clear_patron_data" => "users#clear_patron_data"
    post "toggle_application_status" => "application_details#toggle_application_status"
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login', to: redirect { |params, request| "#{ENV['MARLI_RELATIVE_URL_ROOT']}/users/auth/nyulibraries?#{request.query_string}" }, as: :login
  end

  get "new_registration" => "users#new_registration", as: :register
  patch "create_registration" => "users#create_registration"
  get "confirmation" => "users#confirmation"

  get '/robots.txt' => 'application#robots'

  get '/healthcheck' => 'application#healthcheck'

  root :to => "users#new_registration"
end
