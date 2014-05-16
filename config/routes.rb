Drwho::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "user_registrations", :sessions => "user_sessions" }    
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

  # SelfLearnings
  get 'study/self_learnings', :to => 'self_learnings#index', :as => :self_learnings
  post 'study/self_learnings', :to => 'self_learnings#create'
  get 'study/self_learning/new', :to => 'self_learnings#new', :as => :self_learning_new
  get 'study/self_learning/:grouping_id', :to => 'self_learnings#show', :as => :self_learning
  patch 'study/self_learning/:grouping_id', :to => 'self_learnings#update'
  delete 'study/self_learning/:grouping_id', :to => 'self_learnings#destroy'
  get 'study/self_learning/:grouping_id/exam', :to => 'self_learnings#exam', :as => :self_learning_exam
  post 'study/self_learning/:grouping_id/exam', :to => 'self_learnings#exam_result'
  get 'study/self_learning/:grouping_id/edit', :to => 'self_learnings#edit', :as => :self_learning_edit


  # Records
  get 'study/records', :to => 'studies#all_records', :as => :study_all_records
  get 'study/records/:uuid', :to => 'studies#record', :as => :study_records
  
  get 'study/wrongs/', :to => 'study_records#wrongs', :as => :wrongs
  get 'study/wrongs/course/', :to => 'study_records#wrongs_by_course', :as => :wrongs_by_course
  get 'study/wrongs/course/:uuid', :to => 'study_records#wrongs_in_course', :as => :wrongs_in_course
  
  get 'study', :to => 'studies#index', :as => :studies

  # Studies
  get "study/set_start_day", :to => 'studies#set_start_day', :as => :set_start_day
  patch 'study/set_start_day/:uuid', :to => 'studies#set_start_day'
  
  get 'study/:uuid', :to => 'studies#show', :as => :study

  get 'study/read/:uuid/day/:day', :to => 'studies#read', :as => :study_read
  post 'study/practice/:uuid/day/:day/phase/:phase', :to => 'studies#practice_submit'
  get 'study/practice/result/:uuid', :to => 'studies#practice_result', :as => :study_practice_result
  get 'study/practice/:uuid/day/:day/phase/:phase', :to => 'studies#practice', :as => :study_practice
  
  post 'study/exam/:uuid/day/:day/phase/:phase/result', :to => 'studies#exam_submit'
  get 'study/exam/:uuid/day/:day/phase/:phase/result', :to => 'studies#exam_result', :as => :study_exam_result
  get 'study/exam/:uuid/day/:day/phase/:phase', :to => 'studies#exam', :as => :study_exam
  
  

  resources :user_orders, :only => [:index, :show, :new]
  resources :courses, :only => [:index, :show]

  get 'portal/:id', :to => 'ads#go', :as => :portal
  root :to => 'home#welcome'

end
