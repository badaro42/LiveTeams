Rails.application.routes.draw do

  resources :geo_entities
  resources :team_members
  resources :teams
  resources :users

  resources :teams do
    resources :users
  end

  # altera as rotas predefinidas do devise
  devise_for :users, :controllers => { registrations: 'registrations' },
             :path => 'account', :path_names => { :sign_in => 'login', :sign_up => 'new', :sign_out => 'logout',
                                                  :password => 'password', :confirmation => 'confirmation' }

  get 'users', to: 'users#index'
  get 'users/show'
  get 'users/edit'

  get 'teams', to: 'teams#index'
  get '/get_geo_stuff', to: 'homepage#get_geo_stuff'


  get 'homepage/index'

  authenticated :user do
    root to: 'homepage#index', as: :authenticated_root
  end
  root to: redirect('/login')

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
    get "/forgot_password" => "devise/passwords#new"
    get "/logout" => "devise/sessions#destroy"
  end


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
