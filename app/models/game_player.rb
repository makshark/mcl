class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  enum role: { mafia: 0, citizen: 1, don: 2, sheriff: 3 }





  def self.normalize_role(role)
    case role
      when 'Мафия'
        'mafia'
      when 'Дон'
        'don'
      when 'Шериф'
        'sheriff'
      else
        'citizen'
    end
  end
end
