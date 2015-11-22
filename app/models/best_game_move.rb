class BestGameMove < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  #TODO: сделать метод, который будет отпределять является ли ход лучшим, или нет (возможно его можно сделать в игре)
end
