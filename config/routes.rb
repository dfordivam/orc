Orc::Application.routes.draw do
  get "users/new"

  get "users/edit"

  resources :users
  get "events/create"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
     match 'home/index_list' => 'home#index_list', :as => :index_list
#     match 'visitors/add_fields_1' => 'visitors#add_fields_1'
#     match 'visitors/additional_info' => 'visitors#additional_info'
  # This route can be invoked with purchase_url(:id => product.id)


  resources :visitors do
    collection do
      post :add_fields_1
      post :add_fields_2
      post :additional_info
    end
  end
  resources :events
  resources :buildings
  resources :rooms
  resources :checkins do
    collection do
      post :roomsearch
    end
  end

  match "checkins/inactivate/:id" => "checkins#inactivate"

  get 'javascripts/checkin' => 'javascripts#checkin'
  get 'javascripts/visitor' => 'javascripts#visitor'

  
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
  # root :to => "welcome#index"
  #root :to => "home#index"
  root :to => "visitors#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
#   match ':controller(/:action(/:id(.:format)))'
end
