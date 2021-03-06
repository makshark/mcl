# TODO: обязательно пофиксть, если обновляешь игрока, то пересчитывать его лучший ход
# TODO: Обязательно добавить в будущем в качестве констант все перестчеты очков для игрока, что бы можно было это легко менять

class GamePlayer < ActiveRecord::Base
  attr_accessor :position
  after_create :calculate_points
  before_save :check_penalty_amount
  belongs_to :game
  belongs_to :player
  enum role: { mafia: 0, citizen: 1, don: 2, sheriff: 3 }

  scope :season, ->(season_id) { joins(:game).where('games.big_tournament_tour_id IS NULL AND games.students_league = false AND games.season_id = ? ', season_id) }
  scope :by_game_month, -> (month_number) { joins(:game).where('extract(month from games.date) = ?', month_number) if month_number.present? && month_number.to_i.nonzero? }


  def self.normalize_role(role)
    role.sub(' ', '') unless role.nil?
    case role
      when 'Мафия'
        'mafia'
      when 'Дон'
        'don'
      when 'Шериф ' || 'Шериф ' #TODO: быстрый костыль, очень странно
        'sheriff'
      else
        'citizen'
    end
  end

  # Иногда возникает ошибка, что penalty amount = nil
  def check_penalty_amount
    self.penalty_amount = 0 if self.penalty_amount.nil?
  end

  #TODO: так же добавить после апдейта игры, пересчет всех сущностей
  #TODO: не забыть добавить штраф
  private def calculate_points
            # подсчет очков для мафия старс турнира (Система MWT)
    if self.game.big_tournament_tour_id.present?
      points_sum = 0
      case role
        when 'mafia'
          self.win? ? points_sum += 2 : points_sum += 0
        when 'don'
          self.win? ? points_sum += 2 : points_sum += 0
        when 'sheriff'
          if self.win?
            points_sum += 2
          else
            #TODO: харкдод не учитывания +0,5 первоубиенном в финале mafiastars
            unless self.game.big_tournament_tour_id == 5
              self.killed_first? ? points_sum += 0.5 : points_sum += 0
            end
          end
        when 'citizen'
          if self.win?
            points_sum += 2
          else
            #TODO: харкдод не учитывания +0,5 первоубиенном в финале mafiastars
            unless self.game.big_tournament_tour_id == 5
              self.killed_first? ? points_sum += 0.5 : points_sum += 0
            end
          end
      end

      #метод лучшего игрока ведущий
      points_sum += 1 if best_leading
      #метод лучшего игрока ведущий 1
      points_sum += 0.5 if best_leading1
      #метод лучшего игрока ведущий 2
      points_sum += 0.5 if best_leading2
      #Обновление записи с очками
      self.update_columns(points: points_sum) # Напрямую обновляем запись минуя валидации
      # студлига
    elsif self.game.students_league
      points_sum = 0
      case role
        when 'mafia'
          self.win? ? points_sum += 3 : points_sum += 0
        when 'don'
          self.win? ? points_sum += 4 : points_sum -= 1
        when 'sheriff'
          if self.win?
            points_sum += 4
          else
            self.killed_first? ? points_sum += 0 : points_sum = -1
          end
        when 'citizen'
          if self.win?
            points_sum += 3
          else
            self.killed_first? ? points_sum += 1 : points_sum += 0
          end
      end

      #метод лучшего игрока стол
      points_sum += 1.1 if best_table
      #метод лучшего игрока ведущий
      points_sum += 0.5 if best_leading
      # умножаем на 2 если финальные игры года и есть поле дабл поинтс
      points_sum *= 2   if game.double_points
      #Обновление записи с очками
      self.update_columns(points: points_sum) # Напрямую обновляем запись минуя валидации
    else
      points_sum = 0
      case role
        when 'mafia'
          self.win? ? points_sum += 3 : points_sum += 0
        when 'don'
          self.win? ? points_sum += 3.5 : points_sum -= 0.5
        when 'sheriff'
          if self.win?
            points_sum += 3.5
          else
            self.killed_first? ? points_sum += 0 : points_sum = -0.5
          end
        when 'citizen'
          if self.win?
            points_sum += 3
          else
            self.killed_first? ? points_sum += 1 : points_sum += 0
          end
      end

      #метод лучшего игрока стол
      points_sum += 0.6 if best_table
      #метод лучшего игрока ведущий
      points_sum += 0.5 if best_leading
      #метод лучшего игрока ведущий 1
      points_sum += 0.3 if best_leading1
      # умножаем на 2 если финальные игры года и есть поле дабл поинтс
      points_sum *= 2   if game.double_points
      #Обновление записи с очками
      self.update_columns(points: points_sum) # Напрямую обновляем запись минуя валидации
    end
  end

  #Лучший игрок по мнению стола
  def best_table
    game.best_player_table_id == self.player_id ? true : false
  end

  #Лучший по мнению ведущего
  def best_leading
    game.best_player_leading_id == self.player_id ? true : false
  end

  # Лучший по мнению ведущего 1
  def best_leading1
    game.best_player_leading1_id == self.player_id ? true : false
  end

  # Лучший по мнению ведущего 2
  def best_leading2
    game.best_player_leading2_id == self.player_id ? true : false
  end

  # Лучший ход игрока убитого в 1 ночь
  # In this case use guard statement
  def best_move
    if self.killed_first? && (role == 'sheriff' || role == 'citizen')
      best_move_count = 0
      BestGameMove.where(game_id: self.game_id).each do |move|
        if move.player_id
          game_player = GamePlayer.where(game_id: self.game_id, player_id: move.player_id).first
          if game_player.try(:role) == 'don' || game_player.try(:role) == 'mafia'
            best_move_count += 1
          end
        end
      end
      if self.game.big_tournament_tour_id.present?
        # TODO: выбор шерифа или мирного и присваивание ему очков
        mcl_tours = [10] # захрадкоженные туры big_tournament_tour_id для которых не нужно считать у первоубиенного лучший ход если выиграли мирные
        if (self.game.big_tournament_tour_id == 10 && self.game.mafia? )
          if role == 'sheriff'
            return 0.25 if best_move_count == 2
            return 0.5 if best_move_count == 3
          elsif role == 'citizen'
            return 0.25 if best_move_count == 2
            return 0.5 if best_move_count == 3
          end
        elsif (self.game.big_tournament_tour_id != 10)
          if role == 'sheriff'
            return 0.25 if best_move_count == 2
            return 0.5 if best_move_count == 3
          elsif role == 'citizen'
            return 0.25 if best_move_count == 2
            return 0.5 if best_move_count == 3
          end
        end
        0
      else
        # TODO: выбор шерифа или мирного и присваивание ему очков
        if role == 'sheriff'
          return 0.3 if best_move_count == 2
          return 0.7 if best_move_count == 3
        elsif role == 'citizen'
          return 0.4 if best_move_count == 2
          return 0.9 if best_move_count == 3
        end
        0
      end
    else
      0
    end
  end

  #Метод который показывает, выиграл игрок или нет
  def win?
    winning_team = game.victory
    if role == 'citizen' || role == 'sheriff'
      winning_team == 'city' ? true : false
    elsif role == 'mafia' || role =='don'
      winning_team == 'mafia' ? true : false
    end
    # TODO: что делать если ничья
  end

  #Метод который определяет убит игрок в первую ночь или нет
  def killed_first?
    game.killed_first_id == self.player_id ? true : false
  end
end
