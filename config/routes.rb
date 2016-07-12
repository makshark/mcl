Rails.application.routes.draw do
  devise_for :admins
  root 'home#main_page'
  resources :players
  resources :mini_tournaments
  resources :big_tournament_tours
  resources :tournament_players_teams
  post '/list_of_players', to: 'players#list_of_players'
  post '/list_of_leadings', to: 'players#list_of_leadings'
  post '/create_game', to: 'games#create_game'
  get '/games', to: 'games#index'
  get '/players_rating', to: 'players#players_rating'
  get '/add_game', to: 'home#index', as: :add_game
  get '/show_game/:id', to: 'games#show_game', as: :show_game
  post '/admin_or_not', to: 'application#admin_or_not'


  get '/mafia_stars', to: 'mafia_stars#index', as: :mafia_stars
  get '/mafia_stars_results/:id', to: 'mafia_stars#mafia_stars_results', as: :mafia_stars_results
  get '/mclcup16/:id', to: 'mafia_stars#mafia_stars_results', as: :mcl_cup
  post :generate_big_tournament_tour_fate, to: 'fates#generate_big_tournament_tour_fate'
  get 'fates/:id', to: 'fates#show', as: :fates
end
