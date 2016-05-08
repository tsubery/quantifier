Rails.application.routes.draw do
  root to: "main#index"
  get "/auth/:provider/callback" => "sessions#create"
  get "/signin" => "sessions#new", :as => :signin
  get "/signout" => "sessions#destroy", :as => :signout
  get "/auth/failure" => "sessions#failure"

  resources :goals,
    only: %i(destroy),
    constraints: { id: /\d+/} do

    collection do
      metric_exists = lambda do |request|
        name = request[:provider_name]
        PROVIDERS[name]&.find_metric(request[:metric_key])
      end

      get ':provider_name/:metric_key',
        constraints: metric_exists,
        action: :edit,
        as: :edit
      post ':provider_name/:metric_key',
        constraints: metric_exists,
        action: :upsert,
        as: :upsert

      post 'reload', action: :reload, as: :reload
    end
  end
  resources :credentials,
    except: %(index show)
end
