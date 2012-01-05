Orc::Application.routes.draw do

# Search functionality 
  match "search/visitors" => 'visitors#index'
  get 'visitors/autocomplete_visitor_name'

  resources :users
  resources :user_sessions
#  resources :user_sessions do
#    collection do
#      post :signup
#      post :add_fields_2
#      post :additional_info
#    end
#  end
  match 'users/new' => 'users#new', :as => :signup
  match 'user_sessions/logout/:id' => 'user_sessions#logout', :as => :logout
  match 'user_sessions/new' => 'user_sessions#new', :as => :login
  
  get "user_sessions/new"
  get "users/new"
  get "users/edit"
  get "events/create"
  # Ravi Added Start
  match 'visitors/checkinfacebox/:registration_id' => 'visitors#checkinfacebox', :as => :checkinfacebox_visitor
  match 'visitors/save_and_continue' => 'visitors#save_and_continue', :as => :save_and_continue
  match 'utilities/uploadexcel' => 'utilities#uploadexcel', :as => :uploadexcel
  match 'utilities/user_list' => 'utilities#user_list', :as => :user_list
  match 'utilities/building_list' => 'utilities#building_list', :as => :building_list
  match 'utilities/event_list' => 'utilities#event_list', :as => :event_list
  match 'utilities/usr_load' => 'utilities#usr_load', :as => :usr_load
  match 'utilities/visitor_load' => 'utilities#visitor_load', :as => :visitor_load
  match 'utilities/cancel_user' => 'utilities#cancel_user', :as => :cancel_user
  match 'utilities/building_load' => 'utilities#building_load', :as => :building_load
  match 'utilities/cancel_building' => 'utilities#cancel_building', :as => :cancel_building
  match 'utilities/event_load' => 'utilities#event_load', :as => :event_load
  match 'utilities/cancel_event' => 'utilities#cancel_event', :as => :cancel_event
  match 'utilities/download_user_list' => 'utilities#download_user_list', :as => :download_user_list
  match 'utilities/download_visitor_list' => 'utilities#download_visitor_list', :as => :download_visitor_list
  match 'utilities/download_building_list' => 'utilities#download_building_list', :as => :download_building_list
  match 'utilities/download_event_list' => 'utilities#download_event_list', :as => :download_event_list
  match 'buildings/add_rooms_to_building/:building_id' => 'buildings#add_rooms_to_building', :as => :add_rooms_to_building
  match 'buildings/add_rooms_to_building_view/:building_id' => 'buildings#add_rooms_to_building_view', :as => :add_rooms_to_building_view
  resources :utilities
  # Ravi Added End

  match 'events/:id/participants' => 'events#participants' , :as => :event_participants

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
  resources :registrations
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
  get 'javascripts/event' => 'javascripts#event'

  
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
#  root :to => "visitors#new"
  root :to => "user_sessions#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
#   match ':controller(/:action(/:id(.:format)))'
end
