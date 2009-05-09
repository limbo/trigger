ActionController::Routing::Routes.draw do |map|
  map.group_add_user 'accounts/:account_id/groups/:id/add/:user', :controller => 'groups', :action => 'add'
  map.group_remove_user 'accounts/:account_id/groups/:id/remove/:user', :controller => 'groups', :action => 'remove'
  map.group_search 'accounts/:account_id/groups/:id/search/', :controller => 'groups', :action => 'search'
  map.account_view 'accounts/view', :controller => 'accounts', :action => 'show'
  map.account_info 'accounts/:id/info', :controller => 'accounts', :action => 'info'
  map.manage_accounts 'accounts/manage', :controller => 'accounts', :action => 'manage'
  map.account_search 'accounts/:account_id/messages/search', :controller => 'messages', :action => 'search'
  map.account_results 'accounts/:account_id/messages/results', :controller => 'messages', :action => 'search'
  map.account_post_message 'accounts/:account_id/messages/', :controller => 'messages', :action => 'create'
  map.resources :accounts do |accounts|
    accounts.resources :messages
    accounts.resources :groups
    accounts.resources :query_filters
  end

  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "accounts"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
