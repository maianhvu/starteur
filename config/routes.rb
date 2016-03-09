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

  # ReportController
  get 'report/:view', to: 'report#view', as: 'view_report'

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

  devise_for :educators, class_name: "Educator", controllers: {
    sessions: 'educators/sessions',
    registrations: 'educators/registrations',
    confirmations: 'educators/confirmations'
  }, path_names: {
    sign_in: 'sign-in',
    sign_out: 'sign-out',
    sign_up: 'register'
  }
  namespace :educators do
    resources :educators, only: [ :index, :new, :create, :show, :edit, :update ]
    resource :educator_sessions, only: [ :new, :create ]
    resources :access_codes, only: [ :index, :show ]
    resources :billing_records, only: [ :index, :new, :create, :show, :edit, :update] do
      collection do
        get 'display_tests'
        get 'purchase_success'
        post 'apply_discount'
      end
    end

    resources :batches, only: [ :index, :create, :show, :edit, :update, :destroy] do
      resources :coeducators, only: [:index, :create, :destroy]
      get 'batch_test_reminder', to: 'batches#batch_test_reminder'
      get 'assign_code_usages', to: 'batches#assign_code_usages'
    end
    resources :batch_users, only: [ :index, :create, :destroy]

    post 'upload', to: 'batch_users#read'
    post 'assign', to: 'batch_users#assign'
    post 'assignall', to: 'batch_users#assignall'
    post 'generate_report', to: 'batch_users#generate_report'
    post 'generate_batch_report', to: 'batch_users#generate_batch_report'

    namespace :admin do
      resources :admins, only: [ :index ] do
        get 'payment_history', to: 'admins#payment_history'
        get 'generate_codes', to: 'admins#generate_codes'
        get 'manage_access_codes', to: 'admins#manage_access_codes'
        post 'generate_access_code', to: 'admins#generate_access_code'
        post 'generate_discount_code', to: 'admins#generate_discount_code'
        post 'generate_promotion_code', to: 'admins#generate_promotion_code'
        post 'transfer_access_codes', to: 'admins#transfer_access_codes'
      end

      resources :promotion_codes, only: [ :index ] do
        post 'assign_code'
      end

      resources :discount_codes, only: [ :index ] do
        post 'assign_code'
      end
    end

    resources :promotion_codes, only: [ :index ] do
      post 'redeem_code', on: :collection
    end

    post 'upload', to: 'batch_users#read'
    get 'allow_access', to: 'batch_users#allow_access'

    resources :password_resets, only: [ :new, :create, :edit, :update ]

    # get 'login', to: 'educator_sessions#new'
    # post 'login', to: 'educator_sessions#create'
    # delete 'logout', to: 'educator_sessions#destroy'

    root to: 'educators/sessions#new'
  end

end
