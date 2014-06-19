Trellisd::Application.routes.draw do
  
  get "messages/index"

  get "messages/new"

  devise_for :users, :controllers => { :registrations => 'registrations' }

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users do
    resources :posts
  end

  get 'users/:id/home', to: 'users#home', as: 'user_home'
  post 'users/:user_id/posts/:id', to: 'posts#destroy', as: 'destroy_post'
  get 'users/:id/settings', to: 'users#settings', as: 'user_settings'
  get 'connections', to: 'connections#index', as: 'connections'
  post 'connections', to: 'connections#connect', as: 'create_connection'
  put 'connections/:id', to: 'connections#accept', as: 'accept_connection'
  post 'connections/:id', to: 'connections#destroy', as: 'destroy_connection'

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
