ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'user', :action => 'index' # should change this
  map.resources :episodes # should remove this

  
  map.resource :session
  map.logout '/logout/', :controller => 'sessions', :action => 'destroy'
  map.login '/login/', :controller => 'sessions', :action => 'new'
  map.register '/register/', :controller => 'users', :action => 'create'
  map.signup '/signup/', :controller => 'users', :action => 'new'
  map.resend_password '/resend_password/', :controller => 'sessions', :action => 'resend_password'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password/', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:code', :controller => 'users', :action => 'reset_password'
  map.change_password '/account/change_password', :controller => 'users', :action => 'change_password'
  map.resend_activation_link '/resend_activation_link/', :controller => 'users', :action => 'resend_activation_link'

  # try adding as nested resource to user 
  map.my_ideas '/my/ideas/', :controller => 'ideas', :action => 'my_ideas'
  map.post_idea_comment '/post/idea/comment/', :controller => 'ideas', :action => 'add_comment'

  map.my_projects '/my/projects/', :controller => 'projects', :action => 'my_projects'
  map.post_project_comment '/post/project/comment/', :controller => 'projects', :action => 'add_comment'
 
  map.my_posted_jobs '/my/posted_jobs/', :controller => 'jobs', :action => 'my_posted_jobs'
  map.my_job_applications '/my/job_applications/', :controller => 'jobs', :action => 'my_job_applications'
 
  # need to RESTify these
  map.remove_location '/remove_location/', :controller => 'users', :action => 'remove_location'

  map.rate '/rate/', :controller => 'rating', :action => 'rate'

  map.resend_invitation '/resend_invitation', :controller => 'invitations', :action => 'resend'

  map.watchlist_ideas '/watchlists/ideas', :controller => 'watchlists', :action => 'ideas'
  map.watchlist_projects '/watchlists/projects', :controller => 'watchlists', :action => 'projects'
  map.watchlist_jobs '/watchlists/jobs', :controller => 'watchlists', :action => 'jobs'
  map.watchlist_profiles '/watchlists/profiles', :controller => 'watchlists', :action => 'profiles'

  map.interest_ideas '/interests/ideas', :controller => 'interests', :action => 'ideas'
  map.interest_projects '/interests/projects', :controller => 'interests', :action => 'projects'

  map.resources :users,
                :jobs,
                :job_applications,
                :watchlists,
                :interests,
                :invitations,
                :comments
                
  map.resources :users, :has_many => [:messages, :comments]
  map.resources :ideas, :has_many => [:projects, :comments]
  map.resources :projects, :has_many => [:jobs, :comments]
  
  map.resources :searches

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
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.

  #    map.connect ':controller/:action/:id'
  #    map.connect ':controller/:action/:id.:format'
end
