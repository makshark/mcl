class HomeController < ApplicationController

  def index
    Game.main_excel_parser
    3/0
  end

end
