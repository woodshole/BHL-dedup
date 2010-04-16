class BooksController < ApplicationController
  before_filter :find_picklist
  
  # GET books_url
  def dupes
    # return all dupes
    @oclc_dupes                 = @picklist.books.find_dupes(:oclc)
    @oclc_and_volume_dupes      = @picklist.books.find_dupes(:oclc_and_volume)
    @title_and_author_dupes     = @picklist.books.find_dupes(:title_and_author)
    @title_and_chronology_dupes = @picklist.books.find_dupes(:title_and_chronology)
    @title_dupes                = @picklist.books.find_dupes(:title)
  end
  
  def index
    @books    = @picklist.books.find(:all)
  end

  # GET new_book_url
  def new
    # return an HTML form for describing a new dupe
  end

  # POST books_url
  def create
    # create a new book
  end

  # GET book_url(:id => 1)
  def show
    @preloaded_picklist = true
    @book = Book.find(params[:id])
    @oclc_dupes                 = @book.find_dupes_by_oclc
    @oclc_and_volume_dupes      = @book.find_dupes_by_oclc_and_volume
    @title_and_author_dupes     = @book.find_dupes_by_title_and_author
    @title_and_chronology_dupes = @book.find_dupes_by_title_and_chronology
    @title_dupes                = @book.find_dupes_by_title
  end

  # GET edit_book_url(:id => 1)
  def edit
    # return an HTML form for editing a specific dupe
  end

  # PUT book_url(:id => 1)
  def update
    # find and update a specific dupe
  end

  # DELETE book_url(:id => 1)
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    flash[:notice] = "#{@book.title} deleted"
    redirect_to(:back)
  end
  
  private
  def find_picklist
    @picklist ||= Picklist.find(params[:picklist_id]) 
  end
    
end
