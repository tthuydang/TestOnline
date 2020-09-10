Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener_web" if Rails.env.development?
  devise_for :users, controller: { registrations: "registrations" }

  scope module: "guest" do
    root "tickets#index"
    resources :histories
    resources :exam

    get "intro" => "/guest/tickets#intro"
    get "oncheckboxchange" => "/guest/exam#oncheckboxchange"
    get "finish" => "/guest/exam#finish"
  end
  scope module: "creator" do
    resources :tickets
    resources :categories
    resources :subtickets
    resources :questions
    post "importfile" => "/creator/questions#importfile"
    get "download_subticket" => "/creator/subtickets#download_subticket"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
