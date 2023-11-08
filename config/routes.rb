Rails.application.routes.draw do
  root 'home#index'
  post 'converted', to: 'home#fetch_exchange_rates'
end
