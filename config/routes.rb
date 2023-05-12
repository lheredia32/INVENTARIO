Rails.application.routes.draw do
  devise_for :users
  root 'dashboard#index'
  resources :products do
    member do
      get :new_movement
      post :create_movement
      get "edit_movement/:movement_id", to: "products#edit_movement", as: "edit_movement"
      patch "update_movement/:movement_id", to: "products#update_movement", as: "update_movement"
      delete "destroy_movement/:movement_id", to: "products#destroy_movement", as: "delete_movement"
    end
  end  
end

=begin

  resources :products do
    member do
      get :new_movement
      post :create_movement                                        # Rutas manuales para crear CRUD solo de las vistas necesarias.
      get :edit_movement
      patch :update_movement

      get "edit_movement/:movement_id", to: "movement#edit"        # Otra forma de crear rutas manuales para crear CRUD solo de las vistas necesarias.
      put "update_movement/:movement_id", to: "movement#update"
    end
    resources :movements, only: [:edit, :create, :update, :new]
  end

=end
