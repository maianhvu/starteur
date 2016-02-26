Rails.application.routes.draw do
  mount LetsencryptPlugin::Engine, at: '/'
  # ---------------------------------------------------------------------------------
  # STARTEUR WEB APP NAMESPACE
  # ---------------------------------------------------------------------------------
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }, path_names: {
    sign_in: 'sign-in',
    sign_out: 'sign-out',
    sign_up: 'register'
  }

  # PagesController
  get 'pages/registration_successful'
  get 'registration-successful', to: 'pages#registration_successful', as: 'registration_successful'

  # DashboardController
  get 'dashboard/index'
  get 'dashboard/report'

  # Application resources
  resources :code_usages, only: [ :create ]
  resources :tests, only: [ :show ] do
    member do
      get 'begin'
      get 'take'
    end

    resources :questions, only: [ :index, :create ]
    resources :answers, only: [ :create ]
  end
  resources :feedbacks, only: [ :create ]

  root to: 'pages#index'

  # ---------------------------------------------------------------------------------
  # STARTEUR EDUCATOR NAMESPACE
  # ---------------------------------------------------------------------------------
  namespace :educators do
    resources :educators, only: [ :index, :new, :create, :show, :edit, :update ]
    resources :educator_sessions, only: [ :new, :create ]
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
