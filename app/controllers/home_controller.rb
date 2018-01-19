class HomeController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  def index
    # Game.main_excel_parser
    @mini_tournaments = MiniTournament.all.order(created_at: :desc)
    @mafia_stars_tours = BigTournamentTour.all.order(created_at: :desc) # TODO: обязательно это исправить
  end

  def main_page

  end

  def archive
    @seasons = Season.where.not(id: 1, current: true)
  end

  def wtire_some_method_for_users
    #I need to create some checklist, in which i will plane my english education
    # Also i mus start to 
  end
end
