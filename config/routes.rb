Rails.application.routes.draw do
  resources :points_settings
  devise_for :admins
  root 'home#main_page'
  resources :players
  resources :mini_tournaments
  resources :big_tournament_tours
  resources :tournament_players_teams
  resources :seasons
  post '/list_of_players', to: 'players#list_of_players'
  post '/list_of_leadings', to: 'players#list_of_leadings'
  post '/create_game', to: 'games#create_game'
  delete '/delete_game/:id', to: 'games#destroy', as: :destroy_game
  get '/games/:season_id', to: 'games#index', as: :games
  get '/players_rating/:season_id', to: 'players#players_rating', as: :players_rating
  get '/add_game', to: 'home#index', as: :add_game
  get '/show_game/:id', to: 'games#show_game', as: :show_game
  post '/admin_or_not', to: 'application#admin_or_not'


  get '/mafia_stars', to: 'mafia_stars#index', as: :mafia_stars
  get '/mafia_stars_results/:id', to: 'mafia_stars#mafia_stars_results', as: :mafia_stars_results
  get '/mclcup16/:id', to: 'mafia_stars#mafia_stars_results', as: :mcl_cup
  post :generate_big_tournament_tour_fate, to: 'fates#generate_big_tournament_tour_fate'
  get 'fates/:id', to: 'fates#show', as: :fates

  # students league hardcode
  get :studliga, to: 'games#studliga'
  get :studliga_games, to: 'games#studliga_games'
  get :studliga_rating, to: 'games#studliga_rating'


  get :archive, to: 'home#archive', as: :archive
end
