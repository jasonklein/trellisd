Trellisd::Application.routes.draw do

  get "admin/index"

  devise_for :users, :controllers => { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users

  resources :posts do
    get 'page/:page', action: :index, on: :collection
    get 'page/:page', action: :category_index, on: :collection
  end

  resources :messages, only: [:index, :create, :destroy] do
    member do
      get :reply
    end
  end

  resources :admin

  get 'users/:id/home', to: 'users#home', as: 'user_home'
  post 'posts/:id', to: 'posts#destroy', as: 'destroy_post'
  get 'users/:id/settings', to: 'users#settings', as: 'user_settings'
  get 'connections', to: 'connections#index', as: 'connections'
  post 'connections', to: 'connections#connect', as: 'create_connection'
  put 'connections/:id', to: 'connections#accept', as: 'accept_connection'
  post 'connections/:id', to: 'connections#destroy', as: 'destroy_connection'
  post 'messages/:id', to: 'messages#destroy', as: 'delete_message'
  get 'messages/:sender_id/:recipient_id/:post_id', to: 'messages#new', as: 'new_message'
  put 'messages/:id', to: 'messages#create_reply'
  post 'user_flags/:flagger_id/:flagged_id', to: 'user_flags#create', as: 'create_user_flag'
  post 'user_flags/:id', to: 'user_flags#destroy', as: 'destroy_user_flag'
  post 'post_flags/:flagger_id/:post_id', to: 'post_flags#create', as: 'create_post_flag'
  post 'post_flags/:id', to: 'post_flags#destroy', as: 'destroy_post_flag'
  get 'posts/categories/:title', to: 'posts#category_index', as: 'posts_category'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
