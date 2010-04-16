# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    session[:institution_id] != nil && !session[:institution_id].empty?
  end
  
  def current_institution
    @institution ||= Institution.find( session[:institution_id] ) rescue nil
  end
end
