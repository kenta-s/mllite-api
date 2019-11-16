Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :ml_models do
        resources :upload_csv, only: [:create], controller: 'ml_models/upload_csv'
      end
    end
  end
end
