class BigTournamentToursController < ApplicationController
  before_action :set_big_tournament_tour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  # GET /big_tournament_tours
  # GET /big_tournament_tours.json
  def index
    @big_tournament_tours = BigTournamentTour.all
  end

  # GET /big_tournament_tours/1
  # GET /big_tournament_tours/1.json
  def show
  end

  # GET /big_tournament_tours/new
  def new
    @big_tournament_tour = BigTournamentTour.new
  end

  # GET /big_tournament_tours/1/edit
  def edit
  end

  # POST /big_tournament_tours
  # POST /big_tournament_tours.json
  def create
    @big_tournament_tour = BigTournamentTour.new(big_tournament_tour_params)

    respond_to do |format|
      if @big_tournament_tour.save
        format.html { redirect_to @big_tournament_tour, notice: 'Big tournament tour was successfully created.' }
        format.json { render :show, status: :created, location: @big_tournament_tour }
      else
        format.html { render :new }
        format.json { render json: @big_tournament_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /big_tournament_tours/1
  # PATCH/PUT /big_tournament_tours/1.json
  def update
    respond_to do |format|
      if @big_tournament_tour.update(big_tournament_tour_params)
        format.html { redirect_to @big_tournament_tour, notice: 'Big tournament tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @big_tournament_tour }
      else
        format.html { render :edit }
        format.json { render json: @big_tournament_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /big_tournament_tours/1
  # DELETE /big_tournament_tours/1.json
  def destroy
    @big_tournament_tour.destroy
    respond_to do |format|
      format.html { redirect_to big_tournament_tours_url, notice: 'Big tournament tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_big_tournament_tour
      @big_tournament_tour = BigTournamentTour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def big_tournament_tour_params
      params.require(:big_tournament_tour).permit(:name, :big_tournament_id, :list_of_players, :public)
    end
end
