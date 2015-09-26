Rails.application.routes.draw do
  scope module: 'api' do
    resources :users, only: :create

    post 'register', to: 'users#create', as: :register
    get 'confirm/:escaped_email/:token', to: 'users#confirm', as: 'confirm', :constraints => { :escaped_email => /[^\/]+/ }
    post 'sign-in', to: 'users#sign_in'
  end

end
