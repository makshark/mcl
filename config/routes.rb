Rails.application.routes.draw do
  root 'home#main_page'
  post '/list_of_players', to: 'players#list_of_players'
  post '/list_of_leadings', to: 'players#list_of_leadings'
  post '/create_game', to: 'games#create_game'
  get '/games', to: 'games#index'
  get '/players_rating', to: 'players#players_rating'
  get '/add_game', to: 'home#index', as: :add_game
  get '/show_game/:id', to: 'games#show_game', as: :show_game
end
