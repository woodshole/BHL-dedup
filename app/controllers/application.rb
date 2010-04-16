# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Dedup_Tool'
  
  before_filter :login_required
  
  
  private
    def login_required      
      unless authorized?
        flash[:notice] = "Please log in"
        redirect_to new_session_path
      end
    end
    
    def authorized?
      session[:institution_id] != nil && !session[:institution_id].empty?
    end
    
    def current_institution
      @institution ||= Institution.find( session[:institution_id] ) rescue nil
    end
    
end
