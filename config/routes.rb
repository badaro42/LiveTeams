Rails.application.routes.draw do

  # routes para as paginas de permissões!
  get 'permissions', to: 'user_role#index', as: :permissions
  post 'permissions', to: 'user_role#create', as: :permission_create
  delete 'permissions', to: 'user_role#destroy', as: :permission_destroy
  get 'permissions/reset_filters', to: 'user_role#reset_filters'

  # rota para o SSE :)
  get '/entity_updates' => 'homepage#entity_updates'

  # rotas para as chamadas ajax na pagina principal
  get '/teams/teams_to_json', to: 'teams#teams_to_json'
  get '/geo_entities/geo_entities_to_json', to: 'geo_entities#geo_entities_to_json'
  get '/teams/reverse_geocode_coords', to: 'teams#reverse_geocode_coords'
  get '/geocode_location', to: 'homepage#geocode_location'
  get '/teams/get_teams_by_profile', to: 'teams#get_teams_by_profile'

  # rota para obter o perfil do utilizador
  get 'users/get_user_profile', to: 'users#get_user_profile'

  # altera as rotas predefinidas do devise
  devise_for :users, :controllers => { registrations: 'registrations' },
             :path => 'account', :path_names => { :sign_in => 'login', :sign_up => 'new', :sign_out => 'logout',
                                                  :password => 'password', :confirmation => 'confirmation' }


  delete '/users/:id' => 'users#destroy', as: :test_destroy_user
  delete '/team_members' => 'team_members#destroy'
  resources :geo_entities
  resources :team_members
  resources :teams
  resources :users

  # resources :user_role

  resources :teams do
    resources :users
  end


  get 'users', to: 'users#index'
  get 'users/show'
  get 'users/edit'

  # TESTE: ATUALIZAR AS COORDENADAS DO UTILIZADOR
  post '/update_location' => 'users#update_location'

  post '/add_user_to_team' => 'teams#add_user_to_team'
  post '/remove_user_from_team' => 'teams#remove_user_from_team'

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


  # esta rota deve ser a ultima!!!!
  # isto porque o rails avalia as rotas por ordem, de cima para baixo.
  # se nenhuma das rotas de cima foi apanhada, é porque não existe e redireciona para a raiz do projeto
  get '*path' => redirect('/')



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
