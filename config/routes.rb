EventApp::Application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :tags
  resources :users
  resources :events

  root :to => "publics#index"

  get '/', to: "publics#index"
  post '/search/', to: 'publics#search'
  get '/search/', to: 'publics#search'

  get '/user/location/', to: 'users#location'
  # post '/user/home/',to: 'users#home'
  get '/user/recommendations/',to: 'users#home'

  get '/event/new/', to: 'events#new'
  post '/event/create/', to: 'events#create'

  get '/event/console/', to: 'events#event_console'
  post '/event/add_photo/', to: 'events#set_photo'

  get '/event/user_created/', to: 'events#user_created_events'

  get '/user/search/', to: 'users#search'
  post '/user/search_results/', to: 'users#search_results'

  get '/user/info/', to: 'users#user_info'
  get '/user/public/', to: 'users#user_public'
  get '/user/friends/', to: 'users#user_friends'
  post '/user/send_request/', to: 'users#send_friend_request'
  post '/user/accept_request/', to: 'users#accept_friend_request'
  post '/user/reject_request/', to: 'users#reject_friend_request'

  get '/public/attendee_list/', to: 'publics#attendee_list'

  post '/event/attend/', to: 'events#attend_event'
  post '/event/maybe/', to: 'events#maybe_event'
  post '/event/not_going/', to: 'events#not_going_event'

  get '/user/friend_requests/', to: 'users#pending_friend_requests'
  get '/user/event_invitations/', to: 'users#pending_invitations'

  get '/event/invite_search/', to: 'events#invite_search'
  post '/event/invite_result/', to: 'events#invite_search_results'
  get '/event/invite_user/', to: 'events#invite_user'
  post '/event/invite/', to: 'events#invite'
  post '/event/accept_invitation/', to: 'events#accept_invitation'
  post '/event/maybe_invitation/', to: 'events#maybe_invitation'
  post '/event/reject_invitation/', to: 'events#reject_invitation'

  get '/event/info/', to: 'publics#event_info'
  get '/event/user/', to: 'events#event_user'
  get '/event/public/', to: 'publics#event_public'

  get '/admin/confirm_list/', to: 'admins#non_confirmed_events'
  post '/admin/confirm_event/', to: 'admins#confirm_event'
  post '/admin/delete_event/', to: 'admins#delete_event'

  get '/admin/search/', to: 'admins#search_admin'
  post '/admin/search_results/', to: 'admins#search_results_admin'
  
  get '/admin/user_info/', to: 'admins#user_admin'
  post '/admin/block_user/', to: 'admins#block_user'
  post '/admin/unblock_user/', to: 'admins#unblock_user'

  get '/event/invite_email/', to: 'events#invite_via_email'
  post '/event/send_email/', to: 'events#send_email_invitation'

  get '/user/profile/', to: 'users#profile'
  get '/user/friends_list/', to: 'users#friends'


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
