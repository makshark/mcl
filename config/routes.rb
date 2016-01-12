Rails.application.routes.draw do
  root 'home#index'
  post '/list_of_players', to: 'players#list_of_players'
  post '/list_of_leadings', to: 'players#list_of_leadings'
  post '/create_game', to: 'games#create_game'
end
