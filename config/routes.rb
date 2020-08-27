Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener_web" if Rails.env.development?
  devise_for :users, controller: { registrations: "registrations" }
  resources :charges
  scope module: "guest" do
    root "welcome#index"
    get "exam", to: "/guest/tickets#index"
    post "exam", to: "/guest/tickets#create"
    get "exam/new", to: "/guest/tickets#new"
    get "exam/:id/edit", to: "/guest/tickets#edit"
    get "exam/:id", to: "/guest/tickets#show"
    patch "exam", to: "/guest/tickets#update"
    put "exam", to: "/guest/tickets#update"
    delete "exam", to: "/guest/tickets#destroy"
  end
  scope module: "creator" do
    resources :tickets
    resources :categories
    resources :subtickets
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
