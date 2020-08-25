Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener_web" if Rails.env.development?
  devise_for :users, controller: { registrations: "registrations" }
  resources :charges
  scope module: "guest" do
    root "welcome#index"
  end
  scope module: "creator" do
    resources :tickets
    resources :categories
    resources :subtickets
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
