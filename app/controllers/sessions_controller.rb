class SessionsController < ApplicationController
  before_filter :login_from_cookie, :except => :destroy
  
  # POST session_url
  def create
    # create a session      
    session[:institution_id] = params[:institution]    
    redirect_to picklists_path
  end

  # GET new_session_url
  def new
    # return an HTML form for describing the new session
    @institutions = Institution.find(:all, :order => 'name')
  end

  # GET session_url
  def show
    # find and return the session
  end

  # GET edit_session_url
  def edit
    # return an HTML form for editing the session
  end

  # PUT session_url
  def update
    # find and update the session
  end

  # DELETE session_url
  def destroy
    # delete the session
    session.delete
    flash[:notice] = "You have successfully been logged out"
    redirect_to new_session_path    
  end

  private
    def login_from_cookie    
      if session[:institution_id] != nil && !session[:institution_id].empty?
        redirect_to picklists_path
      end
    end
  
    def authorized?
      true
    end
end
