class MiniTournamentsController < ApplicationController
  before_action :set_mini_tournament, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:create, :update, :destroy]
  # GET /mini_tournaments
  # GET /mini_tournaments.json
  def index
    @mini_tournaments = MiniTournament.where('extract(year from mini_tournaments.created_at) = 2017').order(created_at: :desc)
  end

  # GET /mini_tournaments/1
  # GET /mini_tournaments/1.json
  def show
    # TODO: В будущем при рефакторинге сделать умный класс mini tournament
    @mini_tournament_players = {}
    @mini_tournaments_games = Game.where(mini_tournament_id: @mini_tournament.id).order(:created_at)
    @mini_tournaments_games.each_with_index do |game, index|

      players_of_game = GamePlayer.where(game_id: game.id)
      game_symbol = ('game_' + (index + 1).to_s).to_sym

      players_of_game.each do |player|
        nick = player.player.nick
        @mini_tournament_players[nick] ||= {}
        @mini_tournament_players[nick][:remarks] || @mini_tournament_players[nick][:remarks] = 0
        @mini_tournament_players[nick][game_symbol] = player.points.to_s
        @mini_tournament_players[nick][:remarks] += player.remark
      end
    end
    total = 0
    @mini_tournament_players.each do |k, v|
      v.each do |one_player_k, one_player_v|
        total += one_player_v.to_f if one_player_k != :total && one_player_k != :remarks
      end
      @mini_tournament_players[k][:total] = total.round(1)
      total = 0
    end
    @mini_tournament_players = @mini_tournament_players.sort_by { |_, value| value[:total] }.reverse.to_h
    colors = %w(#FFD700 #FFE647 #FFFC65)
    @mini_tournament_players.each_with_index do |player, index|
      @mini_tournament_players[player.first][:colors] = colors[index]
      break if index == 2
    end
  end

  # GET /mini_tournaments/new
  def new
    @mini_tournament = MiniTournament.new
  end

  # GET /mini_tournaments/1/edit
  def edit
  end

  # POST /mini_tournaments
  # POST /mini_tournaments.json
  def create
    @mini_tournament = MiniTournament.new(mini_tournament_params)

    respond_to do |format|
      if @mini_tournament.save
        format.html { redirect_to @mini_tournament, notice: 'Mini tournament was successfully created.' }
        format.json { render :show, status: :created, location: @mini_tournament }
      else
        format.html { render :new }
        format.json { render json: @mini_tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mini_tournaments/1
  # PATCH/PUT /mini_tournaments/1.json
  def update
    respond_to do |format|
      if @mini_tournament.update(mini_tournament_params)
        format.html { redirect_to @mini_tournament, notice: 'Mini tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @mini_tournament }
      else
        format.html { render :edit }
        format.json { render json: @mini_tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mini_tournaments/1
  # DELETE /mini_tournaments/1.json
  def destroy
    @mini_tournament.destroy
    respond_to do |format|
      format.html { redirect_to mini_tournaments_url, notice: 'Mini tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_mini_tournament
    @mini_tournament = MiniTournament.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mini_tournament_params
    params.require(:mini_tournament).permit(:name)
  end
end
