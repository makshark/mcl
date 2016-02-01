class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # Check admin or not

  def admin_or_not
    render json: current_admin.present? ? true : false
  end

end
