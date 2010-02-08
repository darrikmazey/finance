ActionController::Routing::Routes.draw do |map|
  map.resources :work_items, :member => { :open => [ :post ], :close => [ :post ] }

  map.resources :accounts

  map.resources :rates

  map.resources :projects

  map.resources :invoices

  map.resources :clients

  map.resources :transactions

  map.resources :users, :collection => { :login => [:get, :post], :logout => [:get] }, :has_many => [:accounts]

	#map.resources :billing_accounts, :controller => 'accounts'
  map.resources :accounts, :has_many => :transactions, :collection => { :ajax_list => [ :post ], :parents => [ :post ] }, :member => { :large_graph => [ :get ] }

	map.quick_switch '/users/quick_switch/:id', :controller => 'users', :action => 'quick_switch'

	map.account_graph '/graphs/account/:id', :controller => 'graphs', :action => 'account'
	map.summary_graph '/graphs/summary', :controller => 'graphs', :action => 'summary'

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
  map.root :controller => 'accounts'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
