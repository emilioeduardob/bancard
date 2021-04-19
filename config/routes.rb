Bancard::Engine.routes.draw do
  resources :transactions, only: [] do
    collection do
      post :confirm
    end
    member do
      get :return_url
      get :commission
      post :process_id
    end
  end
end
