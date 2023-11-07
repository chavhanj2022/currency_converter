Rails.application.routes.draw do
  root 'home#index'
  # get 'converter', to: 'converter#fetch_exchange_rates'
  post 'converted', to: 'home#fetch_exchange_rates'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
