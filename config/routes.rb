Rails.application.routes.draw do
  scope '/auth' do
    post '/signin', to: 'user_token#create'
    post '/signup', to: 'users#create'
  end

  namespace :api do
    namespace :v1 do
      resources :users do
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :articles do
        resources :comments do
        end
      end
    end
  end
end
