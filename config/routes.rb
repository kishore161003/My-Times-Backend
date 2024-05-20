Rails.application.routes.draw do
  resources :website_visits
  resources :websites
  resources :users do
    collection do
      match '', to: 'users#options', via: [:options]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post '/login', to: 'users#login'

  delete '/users', to: 'users#destroy_all', as: 'delete_all_users'

  delete '/all_websites_visits', to: 'website_visits#destroy_all', as: 'delete_all_visits'

  delete '/all_websites', to: 'websites#destroy_all', as: 'delete_all_websites'

  get 'user_websites/:user_id', to: 'websites#user_websites'

  post '/update_data', to: 'websites#update_data'

  get '/total_time_stats/:user_id', to: 'website_visits#total_time_stats'


   get 'websites/time_spent_today/:user_id', to: 'websites#time_spent_today'

  get 'websites/time_spent_past_week/:user_id', to: 'websites#time_spent_past_week'

  get 'websites/time_spent_past_month/:user_id', to: 'websites#time_spent_past_month' 

  get 'websites/time_spent_past_month/:user_id/:url', to: 'websites#time_spent_past_month_for_website', constraints: { url: /.*/ }

get '/domains/time_spent_past_month/:user_id/:domain', to: 'websites#time_spent_past_month_for_domain'

get '/websites/with_restriction_or_timeout/:user_id', to: 'websites#with_restriction_or_timeout'

put '/websites/:id', to: 'websites#update_restriction_and_timeout'

post '/update_timeout_data', to: 'websites#update_timeout_data'

post '/update_restricted_data', to: 'websites#update_restricted_data'




  # Defines the root path route ("/")
  # root "posts#index"
end
