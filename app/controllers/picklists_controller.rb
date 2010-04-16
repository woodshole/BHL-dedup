class PicklistsController < ApplicationController
  # GET picklists_url
  def index
    # return all picklists
    @picklists = current_institution.picklists.find :all
  end

  # GET new_picklist_url
  def new
    # return an HTML form for describing a new picklist
  end

  # POST picklists_url
  def create
    @picklist = current_institution.picklists.new(params[:picklist])
    if @picklist.save
      flash[:notice] = "#{@picklist.filename} added"
      redirect_to picklists_url()
    else
      render :action=>'new'
    end
  end

  # GET picklist_url(:id => 1)
  def show
    @picklist = Picklist.find(params[:id])
    
    respond_to do |format|
      format.html
      format.csv { send_data @picklist.to_csv, :type => "text/plain", :filename=>"#{@picklist.base_filename}.csv", :disposition => 'attachment' }
    end
  end

  # GET edit_picklist_url(:id => 1)
  def edit
    # return an HTML form for editing a specific picklist
  end

  # PUT picklist_url(:id => 1)
  def update
    # find and update a specific picklist
  end

  # DELETE picklist_url(:id => 1)
  def destroy
    @picklist = current_institution.picklists.find(params[:id])
    @picklist.destroy
    
    flash[:notice] = "#{@picklist.filename} deleted"
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "You do not have privileges to delete #{params[:id]}"
  ensure 
    redirect_to picklists_url
  end
    
end