Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener_web" if Rails.env.development?
  devise_for :users, controller: { registrations: "registrations" }
  resources :charges

  scope module: "guest" do
    root "tickets#index"
    resources :histories
    resources :exam
    resources :users
    resources :competition

    get "intro" => "/guest/tickets#intro"
    get "oncheckboxchange" => "/guest/exam#oncheckboxchange"
    get "finish" => "/guest/exam#finish"
    get "confirm" => "/guest/competition#confirm"
    post "confirm_code" => "/guest/competition#confirm_code"
  end

  scope module: "creator" do
    resources :tickets
    resources :categories
    resources :subtickets
    resources :questions
    resources :histories

    post "importfile" => "/creator/questions#importfile"
    get "download_subticket" => "/creator/subtickets#download_subticket"
    get "creator/history" => "/creator/histories#history"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
