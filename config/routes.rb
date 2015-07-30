Rails.application.routes.draw do
  root to: 'main#welcome'
  get '/main/about', to: 'main#about'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  resources :providers,
    param: :name,
    only: :index do
    get '', action: :edit, as: :edit,
      constraints: { provider_name: /#{Rails.configuration.provider_names.join('|')}/ }
    post '', action: :upsert, as: :upsert,
      constraints: { provider_name: /#{Rails.configuration.provider_names.join('|')}/ }
  end
end
