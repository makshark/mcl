# TODO: обязательно пофиксть, если обновляешь игрока, то пересчитывать его лучший ход
# TODO: Обязательно добавить в будущем в качестве констант все перестчеты очков для игрока, что бы можно было это легко менять

class GamePlayer < ActiveRecord::Base
  attr_accessor :position
  after_create :calculate_points
  belongs_to :game
  belongs_to :player
  enum role: { mafia: 0, citizen: 1, don: 2, sheriff: 3 }


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
    else
      points_sum = 0
      case role
        when 'mafia'
          self.win? ? points_sum += 3 : points_sum += 0
        when 'don'
          self.win? ? points_sum += 4 : points_sum -=1
        when 'sheriff'
          if self.win?
            points_sum += 4
          else
            self.killed_first? ? points_sum += 0 : points_sum =-1
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
            return 0 if best_move_count == 2
            return 0.25 if best_move_count == 3
          elsif role == 'citizen'
            return 0.25 if best_move_count == 2
            return 0.5 if best_move_count == 3
          end
        elsif (self.game.big_tournament_tour_id != 10)
          if role == 'sheriff'
            return 0 if best_move_count == 2
            return 0.25 if best_move_count == 3
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

# k - id игрока, value - победа или нет если победа +1

results = {}

winrate = {}

game_ids = Game.current_season.where(students_league: false).pluck(:id)
b = GamePlayer.where(game_id: game_ids)


b.each do |game_player|
  # winning_team = game_player.game.victory
  if game_player.role == 'citizen' || game_player.role == 'sheriff'
      if results[game_player.player_id].present?
        results[game_player.player_id] += 1
      else
        results[game_player.player_id] = 1
      end
    end
end

# game_count = Game.current_season.where(students_league: false).joins(:game_players).where("game_players.player_id = ? AND game_players.role = 1", k).count


results.each do |k, v|
     game_ids = Game.current_season.where(students_league: false).where(killed_first_id: k).count
     # game_count = GamePlayer.where(game_id: game_ids).where(player_id: k, role: 2).count
    #считаем винрейт
    w = (100.to_f / v) * game_ids
    winrate[Player.find(k).nick] = w
end

d = Hash[winrate.sort_by { |_,v| v }.reverse]

t = ''
d.each do |k,v|
  t +=  "#{Player.find(k).try(:nick)}" + "   #{v}   "
end

#enum role: { mafia: 0, citizen: 1, don: 2, sheriff: 3 }

# best game move ---------------------------------------------------------------------------------------------------------
game_count = {}
best_count = {}
total = {}

games = Game.current_season.where(students_league: false)

games.each do |game|
  if game.killed_first_id.present?
    if game_count[game.killed_first_id].present?
      game_count[game.killed_first_id] += 1
    else
      game_count[game.killed_first_id] = 1
    end
    game_player = GamePlayer.where(game_id: game.id, player_id: game.killed_first_id).first
    if (game_player.role == 'sheriff' || game_player.role == 'citizen')
      best_move_count = 0
      BestGameMove.where(game_id: game.id).each do |move|
        if move.player_id
          game_player = GamePlayer.where(game_id: game.id, player_id: move.player_id).first
          if game_player.try(:role) == 'don' || game_player.try(:role) == 'mafia'
            best_move_count += 1
          end
        end
      end
      if best_move_count == 2 || best_move_count == 3
        if best_count[game.killed_first_id].present?
          best_count[game.killed_first_id] += 1
        else
          best_count[game.killed_first_id] = 1
        end
      end
    end
  end
end


best_count.each do |k, v|
  total[Player.find(k).nick] = (100.to_f / game_count[k]) * v
end





d = Hash[total.sort_by { |_,v| v }.reverse]

t = ''
d.each do |k,v|
  t +=  "#{Player.find(k).try(:nick)}" + "   #{v}   "
end



# игровые роли и место за игровым столом
game_ids = Game.current_season.where(students_league: false).pluck(:id)
game_players = GamePlayer.where(game_id: game_ids)

result = {}
new_result = {}

game_players.each do |player|
    if result[player.player.nick].present?
      result[player.player.nick][:remarks] += player.remark
      result[player.player.nick][:games] += 1
    else
      result[player.player.nick] = {}
      result[player.player.nick][:remarks] = 0
      result[player.player.nick][:games] = 0
    end
end

result.each do |k|
  if k[1][:games] > 70
    new_result[k[0]] = k[1][:remarks].to_f / k[1][:games]
  end
end