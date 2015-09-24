Rails.application.routes.draw do
  root to: "main#welcome"
  get "/main/about", to: "main#about"
  get "/auth/:provider/callback" => "sessions#create"
  get "/signin" => "sessions#new", :as => :signin
  get "/signout" => "sessions#destroy", :as => :signout
  get "/auth/failure" => "sessions#failure"
  resources :providers,
    param: :name,
    only: [] do
      resources :goals
    end
  resources :status,
            param: :name,
            only: :index do
    collection do
      post :reload
    end
  end
  resources :goals,
    only: :destroy
end
