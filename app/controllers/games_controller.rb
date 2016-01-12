class GamesController < ApplicationController
  # TODO: обязательно подобавлять по 0.5 за все игры
  # TODO: посмотреть пример с транзакциейв аутсорс пипл и сделать все это действие транзакцией
  def create_game
    # Создаем игру со всеми ее параметрами
    # TODO: создать для каждой лиги настройки, в которых будет храниться игра (что бы понимать номер)
    if game = Game.create(game_params)
      if params[:best_game_move].present?
        params[:best_game_move].each do |best_game_move|
          BestGameMove.create(game_id: game.id, player_id: best_game_move)
        end
      end

      # Создание игроков игры
      # Работа над очками



    end
    render json: { status: 200, message: 'success' }
    # render json: params
  end

  # TODO: создать некое подобие лиг
  private

  def game_params
    params.permit(:date, :leading_id, :victory, :killed_first_id, :best_player_table_id, :best_player_leading_id, :comment)
  end

end
# TODO: возможно в будущем, лучший ход сделать как постгрес аррей, но это не приоритетно