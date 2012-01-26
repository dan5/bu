Bu::Application.routes.draw do

  get "users/test_login"

  resources :user_groups
  resources :comments

  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/logout' => 'sessions#destroy', :as => :logout

  root :to => 'welcome#index'
  get "about" => "welcome#about"

  get "settings/language/:language" => "settings#language"
  get "settings/account" => "settings#account"

  get "cron/update"
  get "my" => "my#index"

  get "users" => "users#index"
  get "users/edit" => "users#edit"
  resources :users

  get "events/:id/delete" => "events#delete"
  get "events/:id/attend" => "events#attend"
  get "events/:id/absent" => "events#absent"
  get "events/:id/maybe"  => "events#maybe"
  resources :events

  get "groups/:id/leave" => "groups#leave"
  get "groups/:id/join" => "groups#join"
  get "groups/:id/request_to_join" => "groups#request_to_join"
  get "groups/:id/delete_request" => "groups#delete_request"
  get "groups/:id/description" => "groups#description"
  get "groups/:id/__destroy__" => "groups#destroy"

  resources :groups do
    get "posts/:renge" => "groups_posts#index"
    resources :posts, :controller => 'groups_posts'
    resources :users, :controller => 'groups_users'
    get "member_requests" => "groups_member_requests#index"
    resources :member_requests, :controller => 'member_requests'
  end

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
  # match ':controller(/:action(/:id(.:format)))'
end
