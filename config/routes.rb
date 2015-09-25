Rails.application.routes.draw do
  namespace :api, path: '/', constraints: { subdomain: :api } do
    resources :users, only: [ :create, :index ]
  end

  post 'register', to: 'api/users#create', as: :register
end
