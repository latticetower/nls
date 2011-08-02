ActionController::Routing::Routes.draw do |map|
  map.resources :history_logs


  map.resources :detail_types
  map.resources :answers, :collection => { :update_individual => :put, 
      :auto_complete_for_answer_detail_supplier_name => :get
          }  

  map.resources :medicines, :active_scaffold => :medicines
  
  map.connect 'answer_details/others_not_found_check', :controller => :answer_details, :action => :others_not_found_check
  map.resources :answer_details, :active_scaffold => :answer_details, :collection => 
      { 
      :auto_complete_for_answer_detail_supplier_name => :get
          }  
  
  map.resources :answers, :active_scaffold => :answers ###


  map.resources :action_lists

  map.resources :letter_states

map.auto_complete ':controller/:action', :requirements => { :action => /auto_complete_for_\S+/ },
 :conditions => { :method => :get }

  map.resources :letter_details, :active_scaffold => :letter_details, :collection => 
      { 
      :auto_complete_for_letter_detail_medicine => :get, 
      :auto_complete_for_letter_detail_measure => :get ,
       :auto_complete_for_letter_detail_boxing_type => :get ,
        :auto_complete_for_letter_detail_manufacturer => :get 
          } 
  map.resources :organization_details

  map.resources :permissions

  map.resources :tactics
  map.connect 'users/edit_details', :controller => :users, :action => :edit_details
  map.resources :users
  map.resources :manufacturers

  map.resources :measures

  map.resources :boxing_types

  map.resources :medicines

  map.resources :countries

  map.resources :roles

  map.resources :organizations
map.resource :session, :controller => 'sessions'

  map.resources :permissions
map.resources :organizations, :active_scaffold => :organizations
map.connect 'letters/:action', :controller => :letters
map.connect 'letters/to_xml/:id', :controller => :letters, :action => :to_xml
  map.resources :letters, :active_scaffold => :letters, :collection => 
      { 
      :auto_complete_for_letter_organization => :get 
          } 
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
   map.root :controller => "letters"
   
map.connect 'login', :controller => :login, :action => "login"
map.connect 'register', :controller => :login, :action => "register"
map.connect 'logout', :controller => :login, :action => "logout"
  # See how all your routes lay out with "rake routes"
  map.resources :roles
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
