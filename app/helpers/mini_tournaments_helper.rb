module MiniTournamentsHelper

  # Проверяет, есть ли у числа остаток, если остаток равен 0 - то число выводится без остатка
  # Так решил сделать Yes
  def print_points_without_zero(point)
    point.to_s.split('.').last == '0' ? point.to_s.split('.').first : point
  end



end
