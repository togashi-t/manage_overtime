module ApplicationHelper
  def your_page?
    current_user.id == params[:id].to_i
  end
end
