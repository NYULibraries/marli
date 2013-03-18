Marli::Application.routes.draw do
  scope "admin" do
    resources :application_details
    resources :users 
    match "auth_settings", :to => "users#auth_types", :as => "auth_settings"
    match "reset_submissions(/:id)", :to => "users#reset_submissions", :as => "reset_submissions"
    match "clear_patron_data", :to => "users#clear_patron_data"
    match "toggle_application_status", :to => "application_details#toggle_application_status"
  end
  
  match 'login', :to => 'user_sessions#new', :as => :login
  match 'logout', :to => 'user_sessions#destroy', :as => :logout
  match 'validate', :to => 'user_sessions#validate', :as => :validate

  match "index_register", :to => "registration#index_register"
  match "register", :to => "registration#register"
  match "send_email", :to => "registration#send_email"
  match "confirmation", :to => "registration#confirmation"
  match "logged_out", :to => "user_sessions#logged_out"
  
  get '/robots.txt' => 'application#robots'
  
  root :to => "registration#index_register"
end