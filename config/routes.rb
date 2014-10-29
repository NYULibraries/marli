Rails.application.routes.draw do
  scope "admin" do
    resources :application_details
    resources :users
    get "auth_settings" => "users#auth_types", as: "auth_settings"
    get "reset_submissions(/:id)" => "users#reset_submissions", as: "reset_submissions"
    get "clear_patron_data" => "users#clear_patron_data"
    get "toggle_application_status" => "application_details#toggle_application_status"
  end

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'validate' => 'user_sessions#validate', :as => :validate

  get "new_registration" => "users#new_registration", as: :register
  post "create_registration" => "users#create_registration"
  get "confirmation" => "users#confirmation"

  get '/robots.txt' => 'application#robots'

  root :to => "users#new_registration"
end
