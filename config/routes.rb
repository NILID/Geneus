Rails.application.routes.draw do
  resources :people do
    member do
      post  :update_father
      post  :update_mother
     # match 'versions/:version', :action => :versions_show, :as => 'version_of', :version => /\d+/
      get :versions
      # match 'versions/compare/:from/:to',
      #   :action => :versions_compare,
      #   :constraints => { :from => /\d+/, :to => /\d+/ }
      get :update_father
      get :update_mother
    end
    collection do
      get   :autocomplete_person_name
    end
    resources :children, :only => [ :create, :destroy ]
  end
  resources :partnerships, :only => [ :create, :destroy ]

  root :to => "people#index"

  # XXX HACK this shouldn't be necessary:
  # match '/people/:id/update_father', :controller => :people, :action => :update_father
  # match '/people/:id/update_mother', :controller => :people, :action => :update_mother

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
