class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:create, :update, :destroy, :index]

  def list_of_players
    render json: Player.pluck(:id, :nick)
  end

  def list_of_leadings
    render json: Player.where(leading: true).pluck(:id, :nick)
  end

  def players_rating
    # Чёрный список (временное очень быстрое решение, в будущем переделать!)
    banned_nicks = ['Клайд']
    @result_array = []
    object = {}
    players_points_count = GamePlayer.current_main_season.group(:player_id).sum(:points)
    players_points_count.each do |player|
      object[:game_count] = GamePlayer.current_main_season.where(player_id: player[0]).count
      object[:nick] = Player.where(id: player[0]).first.try(:nick)
      object[:penalty_amount] = GamePlayer.current_main_season.where(player_id: player[0]).sum(:penalty_amount)
      # 0.25 - это дополнительный коефициент за колличество игр
      object[:rating] = ((player[1] / object[:game_count].to_f) * 100 + object[:penalty_amount] * (-0.5)) + (0.25 * object[:game_count].to_f)
      @result_array << object
      object = {}
    end
    @result_array = @result_array.sort_by { |hsh| hsh[:rating] }.reverse!
    # Получаем колличество игр, которые необходимо сыгать для рейтинга
    game_count = (Game.current_season.count.to_f / 100) * 20 # 20 - колличество процентов
    position = 1
    # В будущем вынести это в настройки к каждому игроку!!!!!
    @result_array.each do |player|
      if banned_nicks.include?(player[:nick])
        player[:position] = 'banned'
      else
        # Отыграл 20 процентов игр, или нет
        if player[:game_count] > game_count
          player[:position] = position
          position += 1
        else
          player[:position] = ''
        end
      end
    end
    render template: 'players/players_rating', locals: { studliga: false }
  end

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def player_params
    params.require(:player).permit(:nick, :leading)
  end
end
