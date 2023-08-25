Rails.application.routes.draw do
  post '/login', to: 'users#create_or_find_user'
  patch 'users/update_token', to: 'users#update_token'
  post '/users/delete_token', to: 'users#delete_token'

  resources :messages do
    collection do
      delete 'delete-chat', to: 'messages#destroy_all'
    end
  end
  mount ActionCable.server => "/cable"
  mount ActionCable.server, at: '/users_cable' # User Channel URL
  mount ActionCable.server, at: '/messages_cable' # Message Channel URL
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
