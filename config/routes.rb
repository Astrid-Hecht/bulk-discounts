Rails.application.routes.draw do

  resources :merchants, except: [:show] do 
    resources :invoices
    resources :items
  end

  get '/merchants/:merchant_id/dashboard', to: 'merchants#show'

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index]
    resources :invoices, only: [:index, :show]
  end

end
