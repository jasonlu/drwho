Drwho::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }
  constraints(:subdomain => /admin|xiulia7n0dshuling/) do
    mount Ckeditor::Engine => '/ckeditor'
    scope :module => "admin", :as => "admin" do
      get "users/search", :to => 'users#search', :as => :search_user
      get "admins/search", :to => 'admins#search', :as => :search_admin
      resources :users
      resources :admins
      resources :orders
      resources :ads

      match "study/set_start_day/", :to => 'studies#set_start_day', via: [:get, :post, :patch], :as => :set_start_day
      match "study/record/(:user_id)", :to => 'studies#record', via: [:get, :post], :as => :study_record
      match "study/wrong_list/(:user_id)", :to => 'studies#wrong_list', via: [:get, :post], :as => :study_wrong_list

      #resources :user_orders
      #get "orders", :to => 'orders#index', :as => :orders
      get "order/:id", :to => 'orders#show', :as => :user_order
      get "order/:id/edit", :to => 'orders#edit', :as => :edit_admin_order
      get "orders/new", :to => 'orders#edit', :as => :new_order
      post "order/:id", :to => 'orders#create'
      patch "order/:id/quickpaid", :to => 'orders#quickpaid', :as => :order_paid
      patch "order/:id", :to => 'orders#update'
      
      delete "orders/:id", :to => 'orders#delete'


      patch "course/:id/hide", :to => 'courses#hide', :as => :hide_course
      patch "course/:id/unhide", :to => 'courses#unhide', :as => :unhide_course
      resources :courses
      resources :messages
      #get 'users', :to => 'user#index', :as => :user
      #get "users", :to => 'users#index'
      #get "users/:id/edit", :to => 'users#edit', :as => :edit_user
      resources :pages
      resources :news
      get "config", :to => 'site_configs#index', :as => :site_configs
      patch "config", :to => 'site_configs#update'
      get "mfg", :to => 'home#edit', :as => :mfg
      patch "mfg", :to => 'home#update'
      root :to => "home#dashboard"
    end
  end
  

  constraints(:subdomain => /^(?!admin)/) do

    #resources :news  
    get "inbox", :to => 'inbox#index', :as => :inbox
    get "inbox/:inbox_id", :to => 'inbox#show', :as => :inbox_show
    put "inbox/read/:id", :to => 'inbox#read', :as => :inbox_read
    #delete "inbox/delete/:id", :to => 'inbox#delete'

    get "news/:title", :to => 'news#show', :as => :news_item
    get "news", :to => 'news#index', :as => :news_index
    get "my_account", :to => 'my_account#profile', :as => :my_account
    get "my_account/profile"
    get "my_account/cart"
    get "my_account/receipt"
    get "my_account/choose_start_day"
    get "my_account/study_record"
    get "my_account/self_learning"
    get "my_account/news"
    get "my_account/logout"

    get "set_start_day", :to => 'user_orders#set_start_day', :as => :set_start_day

    get "calendar", :to => 'my_account#calendar'
    #resources :carts
    

    resources :pages
    resources :site_configs
    #resources :user_profiles
    
    get 'profile', :to => 'user_profiles#show', :as => :user_profiles
    get 'profile', :to => 'user_profiles#show', :as => :user_profile
    get 'profile', :to => 'user_profiles#show', :as => :profile
    patch 'profile', :to => 'user_profiles#update'
    get 'profile/edit', :to => 'user_profiles#edit', :as => :edit_user_profile
    #put 'profile/update', :to => 'user_profiles#update', :as => :user_profiles



    post 'cart/add(.:format)', :to => 'carts#add'
    delete 'cart/:id', :to => 'carts#delete', :as => :delete_cart
    get 'cart', :to => 'carts#show', :as => :cart

    
    get 'order/new/:order_number', :to => 'user_orders#new', :as => :new_user_order
    post 'order/new/:order_number', :to => 'user_orders#new'
    get 'orders', :to => 'user_orders#index', :as => :user_orders
    get 'order/:order_number', :to => 'user_orders#show', :as => :user_order

    
    

    get 'study/self_learnings', :to => 'self_learnings#index', :as => :self_learnings
    post 'study/self_learnings', :to => 'self_learnings#create'
    get 'study/self_learning/new', :to => 'self_learnings#new', :as => :self_learning_new
    get 'study/self_learning/:grouping_id', :to => 'self_learnings#show', :as => :self_learning
    patch 'study/self_learning/:grouping_id', :to => 'self_learnings#update'
    delete 'study/self_learning/:grouping_id', :to => 'self_learnings#destroy'

    get 'study/self_learning/:grouping_id/exam', :to => 'self_learnings#exam', :as => :self_learning_exam
    post 'study/self_learning/:grouping_id/exam', :to => 'self_learnings#exam_result'
    get 'study/self_learning/:grouping_id/edit', :to => 'self_learnings#edit', :as => :self_learning_edit
    


    get 'study/:id', :to => 'studies#show', :as => :study
    get 'study/:id/read', :to => 'studies#read', :as => :read_study
    get 'study/:id/practice', :to => 'studies#practice', :as => :study_practice
    get 'study/:id/exam', :to => 'studies#exam', :as => :exam_study
    post 'study/:id/practice_submit', :to => 'studies#practice_submit'
    post 'study/:id/exam_submit', :to => 'studies#exam_submit'
    
    get 'study/:id/hardests(/course/:course_id)', :to => 'studies#hardests', :as => :hardests_study
    get 'study/:id/records', :to => 'studies#records', :as => :records_study
    #get 'study/:id/edit', :to => 'studies#edit', :as => :edit_study
    #patch 'study/:id', :to => 'studies#update'
    patch 'study/set_start_day/:id', :to => 'studies#set_start_day'
    get 'study', :to => 'studies#index', :as => :studies

    resources :user_orders
    resources :courses
    #resources :click_records

    get 'portal/:id', :to => 'ads#go', :as => :portal
    root :to => 'home#welcome'
  end
  
  

end
