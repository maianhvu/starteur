Rails.application.routes.draw do
  scope module: 'api' do
    resources :users, only: [ :create, :show ]
    resources :tests, only: [ :index, :show ] do
      resources :questions, only: [ :index ]
      resources :answers,   only: [ :create ]
      resources :results,   only: [ :index ]

      get 'use-code/:code', to: 'access_codes#use', as: 'use_code'
    end

    post 'register', to: 'users#create', as: :register
    post 'sign-in', to: 'users#sign_in'
    post 'sign-out', to: 'users#sign_out'

    constraints(escaped_email: /[^\/]+/) do
      get 'confirm/:escaped_email/:token', to: 'users#confirm'
    end

    get 'profile', to: 'users#show'
  end

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

  root to: redirect('http://app.starteur.com/')

  match '*others', to: 'authenticated#allow', via: [ :options ]

end
