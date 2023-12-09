Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "user/sessions",
    registrations: "user/registrations",
    passwords: "user/passwords"
  }

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get "visitors", to: "home#visitors"

  resources :coins, only: [:index]

  resources :portfolios, only: [:index, :show, :new, :create] do
    resources :holdings, only: [:new, :create, :update, :destroy]
  end
end
