Rails.application.routes.draw do
  root 'home#index'
  post '/list_of_players', to: 'players#list_of_players'
end
