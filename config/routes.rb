Spree::Core::Engine.add_routes do
  devise_for :spree_user,
             class_name: Spree::User,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: 'spree/omniauth_callbacks' },
             path: Spree::SocialConfig[:path_prefix]

  devise_scope :spree_user do
    get '/users/auth/wonderful_union/setup', to: 'omniauth_callbacks#setup'
  end

  resources :user_authentications

  get 'account' => 'users#show', as: 'user_root'

  namespace :admin do
    resources :authentication_methods
  end
end
