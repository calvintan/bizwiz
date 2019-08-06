Rails.application.routes.draw do
  resources :graphs do
    resources :datatables do
      collection do
        post :import
      end
    end
  end

  root to: 'graphs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
