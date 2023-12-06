Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "user/sessions",
    registrations: "user/registrations",
    passwords: "user/passwords"
  }


  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  resources :coins, only: [:index]
end
