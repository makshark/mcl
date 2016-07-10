class TournamentPlayersTeamsController < ApplicationController
  before_action :set_tournament_players_team, only: [:show, :edit, :update, :destroy]

  # GET /tournament_players_teams
  # GET /tournament_players_teams.json
  def index
    @tournament_players_teams = TournamentPlayersTeam.all
  end

  # GET /tournament_players_teams/1
  # GET /tournament_players_teams/1.json
  def show
  end

  # GET /tournament_players_teams/new
  def new
    @tournament_players_team = TournamentPlayersTeam.new
  end

  # GET /tournament_players_teams/1/edit
  def edit
  end

  # POST /tournament_players_teams
  # POST /tournament_players_teams.json
  def create
    @tournament_players_team = TournamentPlayersTeam.new(tournament_players_team_params)

    respond_to do |format|
      if @tournament_players_team.save
        format.html { redirect_to tournament_players_teams_path, notice: 'Tournament players team was successfully created.' }
        format.json { render :show, status: :created, location: @tournament_players_team }
      else
        format.html { render :new }
        format.json { render json: @tournament_players_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournament_players_teams/1
  # PATCH/PUT /tournament_players_teams/1.json
  def update
    respond_to do |format|
      if @tournament_players_team.update(tournament_players_team_params)
        format.html { redirect_to tournament_players_teams_path, notice: 'Tournament players team was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament_players_team }
      else
        format.html { render :edit }
        format.json { render json: @tournament_players_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournament_players_teams/1
  # DELETE /tournament_players_teams/1.json
  def destroy
    @tournament_players_team.destroy
    respond_to do |format|
      format.html { redirect_to tournament_players_teams_url, notice: 'Tournament players team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament_players_team
      @tournament_players_team = TournamentPlayersTeam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_players_team_params
      params.require(:tournament_players_team).permit(:player_id, :big_tournament_tour_id, :tournament_players_team_name_id)
    end
end
