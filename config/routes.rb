
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        resources :sleep_sessions, only: [:index] do
          collection do
            post :clock_in
            post :clock_out
          end
        end
        resources :follows, only: [:create, :destroy]
        get :feed, to: "feeds#index"
        resources :users, only: [:create]
      end
    end
  end
end
