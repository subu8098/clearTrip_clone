Rails.application.routes.draw do
  # get "airports/show"

  get '/airports/:key', to: 'airports#show', as: :airport

  # root "posts#index"
end
