Rails.application.routes.draw do
  resources :collections, only: [:index, :create, :show] do
    resources :datatables do
      collection do
        post :import
      end
    end
  end

  resources :graphs, except: [:new] do
    resources :datatables do
    end
  end

  root to: 'collections#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
