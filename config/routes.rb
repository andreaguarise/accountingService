AccountingService::Application.routes.draw do

  resources :database_records


  resources :database_tables


  resources :database_descrs


  resources :database_schemes


  resources :cloud_record_summaries


  resources :storage_summaries


  resources :local_cpu_summaries


  resources :local_cpu_records do
    collection do
      get 'stats'
      match 'search' => 'local_cpu_records#search'
    end
  end


  resources :benchmark_values


  resources :benchmark_types


    resources :grid_cpu_records do
    collection do
      get 'stats'
      match 'search' => 'grid_cpu_records#search'
    end
  end


  resources :blah_records do
    collection do
      match 'search' => 'blah_records#search'
    end
  end


  resources :batch_execute_records do
    collection do
      get 'stats'
      match 'search' => 'batch_execute_records#search'
    end
  end


  resources :roles


  resources :emi_storage_records do
    collection do
      get 'stats'
    end
  end


  get "main/index"

  resources :resource_management do
    collection do
      get 'index' => :index
    end
  end

  resources :publishers

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users

  resources :emi_compute_accounting_records do
    collection do
      get 'stats'
      match 'search' => 'emi_compute_accounting_records#search'
    end
  end

  #   resources :cloud_records

  resources :cloud_records do
    collection do
      get 'stats'
      match 'search' => 'cloud_records#search'
    end
  end

  resources :resources

  resources :resource_types

  resources :sites do
    collection do
      match 'searchid' => 'sites#searchid'
    end
  end

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
  root :to => 'main#index', :as => 'main'
# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
