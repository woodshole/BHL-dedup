require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PicklistsController do
  fixtures :institutions, :picklists, :books
  
  before(:each) do
    login
    
    @picklists = mock("Picklists")
    @current_institution.stub!(:picklists).and_return(@picklists)    
  end

  describe "GET index" do
    
    before(:each) do
      @picklists.stub!(:find).and_return("OMG PICKLISTS LOL!!")
    end
    it "should find all of current_institution's picklists" do
      @current_institution.picklists.should_receive(:find).with(:all)
      do_get
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the correct template" do
      do_get
      response.should render_template(:index)    
    end

    it "should assign the picklists to the @picklists view variable" do
      do_get
      assigns[:picklists].should == @current_institution.picklists.find(:all)
    end

    def do_get page = nil, format = 'html'
      get 'index', :format => format
    end
  end
  
  describe 'GET show' do
    describe 'with a valid ID' do
      before(:each) do
        @picklist = mock_model(Picklist, :filename => 'picked_list.xls', :base_filename => 'picked_list', :to_csv => 'OMG CSV DATA LOL!!')
        Picklist.stub!(:find).and_return(@picklist)
      end
      
      it "should find the correct Picklist" do
        Picklist.should_receive(:find).and_return(@picklist)
        do_get
      end
      
      describe 'requesting CSV' do   
        before(:each) do
          do_get 'csv'
        end
        
        it "should render out CSV" do
          response.body.should == 'OMG CSV DATA LOL!!'
        end
        
        it "should set the type to text/plain" do
          response.headers["type"].should == 'text/plain'
        end
        
        it "should set the disposition to attachment and the filename to picked_list.csv" do
          response.headers["Content-Disposition"].should == "attachment; filename=\"picked_list.csv\""
        end
      end

      describe 'requesting HTML' do
        it "should render picklists/show" do
          do_get 'html'
          response.should render_template('picklists/show')     
        end
      end
      
      def do_get(format='html')
        get :show, :id => 1, :format => format
      end
    end
  end
  
  describe "POST create" do
    
    describe "with valid params" do
      before(:each) do              
        @picklist = mock_model(Picklist, :id => 1, :save => true, :filename =>"uploaded data")
        @picklists.stub!(:new).and_return(@picklist)

        @params = {"uploaded_data"=> 'Uploaded data 10101010101'}
      end

      it "should build a new picklist" do
        @picklists.should_receive(:new).with(@params).and_return(@picklist)
        do_post
      end

      it "should save the picklist" do
        @picklist.should_receive(:save).and_return(true)
        do_post
      end

      it "should redirect to the picklists page when requesting HTML" do
        do_post
        response.should redirect_to("/picklists")
      end

      def do_post format = 'html'
        post 'create', 'picklist' => @params, :format => format
      end
    end

    describe "with invalid parameters" do
      before(:each) do              
        @picklist = mock_model(Picklist, :id => 1, :save => true, :filename =>"uploaded data")
        @picklist.should_receive(:save).and_return(false)
        
        @picklists.stub!(:new).and_return(@picklist)

        @params = {"uploaded_data"=> 'Uploaded data 10101010101'}
      end

      it "should render the new template when requesting HTML" do
        do_post
        response.should render_template(:new)    
      end
      
      def do_post format = 'html'
        post 'create', 'picklist' => @params, :format => format
      end
    end
  end
  
  describe "DELETE destroy" do
    describe "with a valid id" do

      before(:each) do
        @picklist = mock_model(Picklist, :filename => 'picked_list.xls')
        @picklist.stub!(:destroy).and_return(true)
        @picklists.stub!(:find).and_return(@picklist)
      end

      it "should find the correct Picklist" do
        @picklists.should_receive(:find).with(@picklist.id.to_s).and_return(@picklist)
        do_delete
      end

      it "should destroy the Picklist" do
        @picklist.should_receive(:destroy).and_return(true)    
        do_delete
      end

      it "should redirect to Picklist index when requesting HTML" do
        do_delete
        response.should redirect_to("/picklists")
      end

      def do_delete format = 'html'
        delete 'destroy', :id => @picklist.id, :format => format
      end
    end

    describe "with an invalid ID" do

      before(:each) do
        @picklists.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it "should redirect to Picklist index when requesting HTML" do
        do_delete
        response.should redirect_to("/picklists")    
      end

      def do_delete format = 'html'
        delete 'destroy', :id => -1, :format => format
      end
    end
  end
  
  def login
    controller.stub!(:authorized?).and_return(true)
    
    @current_institution = institutions(:mbl)
    
    controller.stub!(:current_institution).and_return(@current_institution)
  end
  
end
