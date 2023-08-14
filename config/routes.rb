Rails.application.routes.draw do
  resources :messages do
    collection do
      delete 'delete-chat', to: 'messages#destroy_all'
    end
  end
  mount ActionCable.server => "/cable"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
