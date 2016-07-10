class FatesController < ApplicationController
  before_action :set_fates, only: [:show]
  before_action :set_big_tournament_tour, only: [:show]
  def generate_big_tournament_tour_fate
    Fate.generate_big_tournament_tour_fate(params[:big_tournament_tour_id])
    redirect_to fates_path(id: params[:big_tournament_tour_id])
  end

  def show
    # просто отрисовываем
  end

  private
  def set_fates
    @fates = Fate.where(big_tournament_tour_id: params[:id]).order(:tour, :table, :place)
  end

  def set_big_tournament_tour
    @big_tournament_tour = BigTournamentTour.where(id: params[:id]).first
  end
end
