Marli::Application.routes.draw do
  scope "admin" do
    resources :patron_statuses
    resources :application_details
    resources :users 
    match "reset_submissions", :to => "users#reset_submissions"
    match "clear_patron_data", :to => "users#clear_patron_data"
    match "toggle_application_status", :to => "application_details#toggle_application_status"
  end

  resources :user_sessions
  
  match 'login', :to => 'user_sessions#new', :as => :login
  match 'logout', :to => 'user_sessions#destroy', :as => :logout
  match 'validate', :to => 'user_sessions#validate', :as => :validate

  match "index_register", :to => "registration#index_register"
  match "register", :to => "registration#register"
  match "send_email", :to => "registration#send_email"
  match "confirmation", :to => "registration#confirmation"
  
  root :to => "registration#index_register"

end
