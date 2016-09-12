I = [:index].freeze
R = [:show, :index].freeze
CR = [:create, *R].freeze
CUD = [:destroy, *CR].freeze
CRU = [:update, *CR].freeze
CRUD = [:destroy, *CRU].freeze

Rails.application.routes.draw do

  mount RailsAdmin::Engine => 'admin', as: 'rails_admin'
  devise_for :admins,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               sign_up: 'register',
               edit: 'admin/edit'
             }

  root to: 'root#index'
  get "log_out" => "root#log_out"

  namespace :v0 do
    resources :users, only: CUD do
      resources :accounts, only: CRUD
    end
    resources :sessions, only: CRUD
  end
end
