Rails.application.routes.draw do
  devise_for :users, controller: { registrations: "registrations" }
  resources :charges

  scope module: "guest" do
    root "tickets#index"

    resources :histories
    resources :exam
    resources :users
    resources :competition
    resources :charges

    get "create_competition" => "/guest/tickets#create_competition"
    get "create_subticket" => "/guest/tickets#create_subticket"
    get "create_ticket" => "/guest/tickets#create_ticket"
    get "help" => "/guest/tickets#help"
    get "intro" => "/guest/tickets#intro"
    get "oncheckboxchange" => "/guest/exam#oncheckboxchange"
    post "finish" => "/guest/exam#finish"
    get "confirm" => "/guest/competition#confirm"
    post "confirm_code" => "/guest/competition#confirm_code"
    get "report_exam" => "/guest/histories#report_exam"
  end

  scope module: "creator" do
    resources :tickets
    resources :categories
    resources :subtickets
    resources :questions
    resources :histories

    get "report_exam" => "/creator/histories#report_exam"
    get "create_competition" => "/creator/tickets#create_competition"
    get "create_subticket" => "/creator/tickets#create_subticket"
    get "create_ticket" => "/creator/tickets#create_ticket"
    get "help" => "/creator/tickets#help"
    post "importfile" => "/creator/questions#importfile"
    get "download_subticket" => "/creator/subtickets#download_subticket"
    get "creator/history" => "/creator/histories#history"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
