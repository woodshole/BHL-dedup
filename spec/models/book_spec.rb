require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Book do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Book.create!(@valid_attributes)
  end
end

describe Book, '#to_csv' do
  fixtures :books
  it "should render valid CSV" do
    books(:mbl_picklist_book_1).to_csv.should == %("0030100483616","16980485","Philosophie anatomique ...","Geoffroy Saint-Hilaire, Etienne, 1772-1844.","v.2","1822","QL845 Geoffroy Saint-Hilaire","J.B. BaillieÌre,","Paris,") 
  end
end

describe Book, 'format_cells' do
  before(:each) do
    @book = Book.new({:picklist_id => 12345, :title=>"Title 1. ", :oclc=>"  16916733   ", :publisher_place=>"  Pub Place 1  ", :internal_identifier=>" 0030100466579 ", :publisher=>"Publisher 1 ", :volume=>"v1 ", :author=>"Author 1 ", :chronology=>"1825 ", :call_number=>"c1 "})
    @book.instance_eval <<-ENDEVAL
      def public_format_cells
        format_cells  # format_cells is a private method. This is a public accessor
      end
    ENDEVAL
  end
  
  it "should be fired on a before_create callback" do
    @book.should_receive(:format_cells)
    @book.save
  end
  
  it "should strip all String fields" do
    @book.public_format_cells
    @book.picklist_id.should         == 12345
    @book.publisher_place.should     == 'Pub Place 1'
    @book.internal_identifier.should == '0030100466579'
    @book.publisher.should           == 'Publisher 1'
    @book.volume.should              == 'v1'
    @book.author.should              == 'Author 1'
    @book.chronology.should          == '1825'
    @book.call_number.should         == 'c1'
  end
  
  it "should strip only the trailing period from the title field" do
    @book.public_format_cells
    @book.title.should == 'Title 1'
    
    @book.title = "Lots.of.friggin.periods."
    @book.public_format_cells
    @book.title.should == 'Lots.of.friggin.periods'
  end
end
