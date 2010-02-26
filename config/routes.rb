ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :comments
  map.resources :account_groups
  map.resources :work_items, :member => { :open => [ :post ], :close => [ :post ] }, :collection => { :all => [ :get ] }, :has_many => :comments
  map.resources :accounts, :collection => { :ajax_index => [ :post ] }
  map.resources :rates
  map.resources :projects
  map.resources :invoices, :member => { :bill => [ :post ], :unbill => [ :post ], :paid => [ :post ], :unpaid => [ :post ] }
  map.resources :clients
  map.resources :transactions
  map.resources :users, :has_many => [:accounts]
  map.resources :accounts, :has_many => :transactions, :collection => { :ajax_list => [ :post ], :parents => [ :post ] }, :member => { :large_graph => [ :get ] }

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
	map.account_graph '/graphs/account/:id', :controller => 'graphs', :action => 'account'
	map.summary_graph '/graphs/summary', :controller => 'graphs', :action => 'summary'

  map.root :controller => 'accounts'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
