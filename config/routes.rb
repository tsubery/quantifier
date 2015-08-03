Rails.application.routes.draw do
  provider_names_regex = /#{Rails.configuration.provider_names.join('|')}/
  root to: "main#welcome"
  get "/main/about", to: "main#about"
  get "/auth/:provider/callback" => "sessions#create"
  get "/signin" => "sessions#new", :as => :signin
  get "/signout" => "sessions#destroy", :as => :signout
  get "/auth/failure" => "sessions#failure"
  resources :providers,
            param: :name,
            only: :index do
    get "", action: :edit, as: :edit,
            constraints: { provider_name: provider_names_regex }
    post "", action: :upsert, as: :upsert,
             constraints: { provider_name: provider_names_regex }
    delete "", action: :destroy, as: :destroy,
               constraints: { provider_name: provider_names_regex }
    collection do
      post :reload
    end
  end
end
