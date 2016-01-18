class Season < ActiveRecord::Base
  # TODO: так же сделать возможность в админке менять эту сущность
  # TODO: это нужно для того, что бы женя мог поменять счетчик
  has_many :games
  # TODO: дописать логику, что если устанавливается в current_true, то все остальные сущности должны установиться в current - false
  def self.current_game_number
    # Тут описывается логика, получения текущего сезона, а текущий сезон у нас будет 6, сейчас это захардкоженно
    current_season = Season.where(current: true).first
    current_season.game_number
  end
end
