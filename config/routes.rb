require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'up', to: proc { [200, {}, ['OK']] }

  # Defines the root path route ("/")
  root to: "pages#home"
  
  resources :quotes do
    resources :line_item_dates, except: [:index, :show] do
      resources :line_items, except: [:index, :show]
    end
  end

  authenticate :user, ->(user) { user.present? } do
    mount Sidekiq::Web, at: '/sidekiq'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
