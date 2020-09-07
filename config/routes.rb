Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener_web" if Rails.env.development?
  devise_for :users, controller: { registrations: "registrations" }

  scope module: 'guest' do
    root "tickets#index"
    resources :histories

    get "exam" => "/guest/tickets#exam"
  end

  scope module: 'creator' do
    resources :tickets
    resources :categories
    resources :questions
    post 'importfile' => "/creator/questions#importfile"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
