# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  post 'messages', to: 'messages#create'
  get 'messages', to: 'messages#show'

  post 'sign_up', to: 'registrations#create'
  post 'sign_in', to: 'sessions#create'
end
