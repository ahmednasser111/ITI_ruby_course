Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  get  "/sign_up", to: "registrations#new"
  post "/sign_up", to: "registrations#create"

  resources :articles do
    member do
      patch :report
    end
  end

  root "articles#index"
end