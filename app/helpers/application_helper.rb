module ApplicationHelper

  # Show tour (base on role and public field)
  # return true if all can see tour
  def public_tour?(public:)
    return true if (public || current_admin.present?)
    false
  end

end
