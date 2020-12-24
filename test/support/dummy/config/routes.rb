Rails.application.routes.draw do
  resources :posts do
    get 'feed', on: :collection
  end
end
