class Game < ActiveRecord::Base
  has_many :players
  has_many :best_game_moves
  has_many :game_players
  belongs_to :killed_first, class_name: Player, foreign_key: :killed_first_id
  belongs_to :best_player_table, class_name: Player, foreign_key: :best_player_table_id
  belongs_to :best_player_leading, class_name: Player, foreign_key: :best_player_leading_id
  belongs_to :leading, class_name: Player, foreign_key: :leading_id


  enum victory: { city: 0, mafia: 1, draw: 2 }


  def self.normalize_victory(victory)
    case victory
      when 'Мирные'
        'city'
      when 'Мафия'
        'mafia'
      else
        'draw'
    end
  end


  #Придумать решение лучше, чем этот костыль

  def self.check_symbol?(symbol)
    #TODO: сказать жене про цифры, именно про цифры в первоубиенных, лучшем ходе и так далее
    #TODO: сказать что бы везде были ссылки на ник, как в 18 игре Ятна под номером 10,
    #TODO: мне самому проверять есть ли игрок, а потом уже вызывать value
    if symbol != '-' && symbol != ' ' && symbol != '=' && symbol != '==' && (!symbol.is_a? Float)
      true
    else
      false
    end
  end

  #TODO: удалить у шерифа пробельчик !
  #TODO: отрефакторить весь метод без value (только в замечаниях оставить его)
  def self.main_excel_parser
    file         = Spreadsheet.open('/home/mak/Desktop/rating.xls')
    list_number  = 2
    while list_number < 268 do
    game_page    = file.worksheet(list_number)
    #Ведущий
    game_leading = game_page.row(1)[8]
    game_leading = Player.where(nick: game_leading.sub(' ', '')).first_or_create(nick: game_leading.sub(' ', ''), leading: true)
    #-----------
    #Вносим и проеряем ники всех игроков
    player_index = 3
    players      = []
    10.times do
      player_nick = game_page.row(player_index)[3]
      players << Player.where(nick: player_nick.sub(' ', '')).first_or_create(nick: player_nick.sub(' ', ''))
      player_index += 1
    end
    #----------------------------------
    #Создаем саму игру и вносим в нее все возможные результаты(лучшие ходы и так далее и тому подобное)
    killed_first_id        = player_nick_by_field(game_page.row(18)[11], players)
    best_player_table_id   = player_nick_by_field(game_page.row(19)[12], players)
    best_player_leading_id = player_nick_by_field(game_page.row(20)[12], players)
    game                   = Game.create(number:                 game_page.row(1)[5].to_i, leading_id: game_leading.try(:id), victory: Game.normalize_victory(game_page.row(1)[13]),
                                         date:                   game_page.row(1)[2].to_date, killed_first_id: killed_first_id.try(:id), best_player_table_id: best_player_table_id.try(:id),
                                         best_player_leading_id: best_player_leading_id.try(:id))
    #----------------------------------
    #Создаем лучший ход (отрфакторить)
    best_value             = 13
    best_move              = []
    3.times do
      # best_move << Player.find_by_nick(game_page.row(18)[best_value].value.sub(' ', '')) if game_page.row(18)[best_value].present? && Game.check_symbol?(game_page.row(18)[best_value])
      best_move << player_nick_by_field(game_page.row(18)[best_value], players)
      best_value +=1
    end

    best_move.each do |one_move|
      BestGameMove.create(game_id: game.id, player_id: one_move.try(:id))
    end
    #----------------------------------
    #Создаем игроков игры
    player_index    = 3
    players_of_game = []
    10.times do
      player_nick    = game_page.row(player_index)[3]
      player_of_game = Player.where(nick: player_nick.sub(' ', '')).first

      players_of_game << GamePlayer.create(game_id: game.id, player_id: player_of_game.id, role: GamePlayer.normalize_role(game_page.row(player_index)[2]), remark: game_page.row(player_index)[13].value.to_i, table_number: game_page.row(player_index)[1])

      player_index += 1
    end
    #----------------------------------
    #Присваивание очков первоубиенному
    if pl = GamePlayer.where(player_id: killed_first_id, game_id: game.id).first
      best_player_move_count = pl.best_move
      total = pl.points + best_player_move_count
      pl.update_attribute(:points, total ) unless best_player_move_count == 0
    end
    #---------------------------------
      list_number +=1
    end
    puts "********************************************************************** #{game.number}"
  end


  #Метод для вычисления ника игрока и возвращения его id-шника
  def self.player_nick_by_field(field, players=[])
    if player = Player.where('nick like ?', field.to_s).first
      player
    else
      if field == '=' || field == ' ' || field == '==' || field == '-' || field == '' || field == nil
        nil
      elsif (1..10).include?(field)
        players[field.to_i - 1]
      else
        Player.find_by_nick(field.try(:value)) || nil
      end
    end
  end
end
