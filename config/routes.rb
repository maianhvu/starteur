Rails.application.routes.draw do
  devise_for :users
  # -------------------------------------------------------------------------------------------------
  # STARTEUR WEB APP NAMESPACE
  # -------------------------------------------------------------------------------------------------
  root to: 'dashboard#index'

  # -------------------------------------------------------------------------------------------------
  # STARTEUR EDUCATOR NAMESPACE
  # -------------------------------------------------------------------------------------------------
  namespace :educators do
    resources :educators, only: [ :index, :new, :create, :show, :edit, :update ]
    resource :educator_sessions, only: [ :new, :create ]
    resources :access_codes, only: [ :index, :show ]
    resources :billing_records, only: [ :index, :new, :create, :show, :edit, :update] do
      collection do
        get 'display_tests'
        get 'purchase_success'
      end
    end

    resources :batches, only: [ :index, :create, :show, :edit, :update, :destroy] do
      resources :coeducators, only: [:index, :create, :destroy]
      get 'batch_test_reminder', to: 'batches#batch_test_reminder'
      get 'assign_code_usages', to: 'batches#assign_code_usages'
    end
    resources :batch_users, only: [ :index, :create, :destroy]

    post 'upload', to: 'batch_users#read'

    resources :password_resets, only: [ :new, :create, :edit, :update ]

    get 'login', to: 'educator_sessions#new'
    post 'login', to: 'educator_sessions#create'
    delete 'logout', to: 'educator_sessions#destroy'

    root to: 'educator_sessions#new'
  end

end
