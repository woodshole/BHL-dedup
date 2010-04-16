require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Picklist do
  before(:each) do
    @valid = Picklist.new()
    @valid.stub!(:temp_path).and_return('spec/picklists/valid.xls')
    
    @invalid = Picklist.new()
    @invalid.stub!(:temp_path).and_return('spec/picklists/invalid.xls')
    
    @non_xls = Picklist.new({:filename => 'ali-g.jpg'});
    @non_xls.stub!(:temp_path).and_return('spec/picklists/ali-g.jpg')
  end

  it "should create a new instance given valid attributes" do
    @valid.should be_valid
  end
  
  it "should invalidate an XLS file that does not contain the specified column headers" do
    @invalid.should_not be_valid
    @invalid.errors.on(:base).should be_include "The \"Local Number\" column must be present in your XLS file"
    @invalid.errors.on(:base).should be_include "The \"Volume\" column must be present in your XLS file"
    @invalid.errors.on(:base).should be_include "The \"Chronology\" column must be present in your XLS file"
    @invalid.errors.on(:base).should be_include "The \"Call Number\" column must be present in your XLS file"
  end
  
  it "should gracefull invalidate a non-XLS file" do
    @non_xls.should_not be_valid
    @non_xls.errors.on(:base).should be_include "Could not read ali-g.jpg. Are you sure it is an XLS document?"
  end
end

describe 'A valid Picklist' do
  
  before(:each) do
    @pl = Picklist.new();
    File.copy('spec/picklists/valid_small.xls', 'spec/picklists/tmp_valid_small.xls')
    @pl.temp_path = 'spec/picklists/tmp_valid_small.xls'
    @pl.stub!(:full_filename).and_return('spec/picklists/valid_small.xls')
  end
  
  after(:each) do
    File.delete 'spec/picklists/tmp_valid_small.xls'
  end
  
  it "should hit the write_books_to_db before_create filter" do
    @pl.should_receive(:write_books_to_db)
    @pl.save
  end
  
  it "should Parse the books before_create" do
    @pl.books.should_receive(:build).once.with({:title=>"Title 1", :oclc=>"16916733", :publisher_place=>"Pub Place 1", :internal_identifier=>"0030100466579", :publisher=>"Publisher 1", :volume=>"v1", :author=>"Author 1", :chronology=>"1825", :call_number=>"c1"})
    @pl.books.should_receive(:build).once.with({:title=>"Title 2", :oclc=>"13928430", :publisher_place=>"Pub Place 2", :internal_identifier=>"0030100489761", :publisher=>"Publisher 2", :volume=>"v2", :author=>"Author 2", :chronology=>"1825", :call_number=>"c2"})
    @pl.books.should_receive(:build).once.with({:title=>"Title 3", :oclc=>"02850928", :publisher_place=>"Pub Place 3", :internal_identifier=>"0030100473948", :publisher=>"Publisher 3", :volume=>"v3", :author=>"Author 3", :chronology=>"1839", :call_number=>"c3"})
    @pl.save
  end
  
  it "should save the books to the database before_create" do
    # Stub magic prevents DB rows from actually being written in the above spec
    @pl.save
    @pl.books.count.should == 3
  end
  
  it "should write the column header mapping to the database" do
    @pl.save
    @pl.header_map.should == { 'OCLC'           => 0,
                               'Local Number'   => 1,
                               'Volume'         => 2,
                               'Chronology'     => 4,
                               'Call Number'    => 5,
                               'Title'          => 6,
                               'Author'         => 7,
                               'Publisher Place'=> 8,
                               'Publisher'      => 9 }
  end
end

describe Picklist, '#to_csv' do
  fixtures :institutions, :picklists, :books
  
  before(:each) do
    @csv = %("Local Number","OCLC","Title","Author","Volume","Chronology","Call Number","Publisher","Publisher Place") << "\n"
    @csv<< %("0030100501300","2825740","American natural history. Part 1.--Mastology.","Godman, John D. (John Davidson), 1794-1830.","v.3","1828","QL715 Godman","H.C. Carey & I. Lea,","Philadelphia,")  << "\n"
    @csv<< %("0030100483616","16980485","Philosophie anatomique ...","Geoffroy Saint-Hilaire, Etienne, 1772-1844.","v.2","1822","QL845 Geoffroy Saint-Hilaire","J.B. BaillieÌre,","Paris,")
  end
  
  it "should call to_csv on all books" do
    picklists(:mbl_picklist).books.each do |book|
      book.should_receive(:to_csv)
    end
    picklists(:mbl_picklist).to_csv
  end
  
  it "should render an appropriate picklist" do
    picklists(:mbl_picklist).to_csv.should == @csv
  end
end

describe Picklist, '#base_filename' do
  it "should remove the extension from the filename" do
    %w(pick_list.xls pick_list.xml pick_list pick_list.dude).each do |picklist_filename|  
      Picklist.new(:filename => picklist_filename).base_filename.should == 'pick_list'
    end 
  end
end

describe Picklist, '#book_attributes' do
  before(:each) do
    @pl = Picklist.new
  end

  it "should convert VALID_COLUMNS from strings to symbols that match the columns in the books table" do
    @pl.book_attributes['Local Number'].should    == :internal_identifier
    @pl.book_attributes['OCLC'].should            == :oclc
    @pl.book_attributes['Title'].should           == :title
    @pl.book_attributes['Author'].should          == :author
    @pl.book_attributes['Volume'].should          == :volume
    @pl.book_attributes['Chronology'].should      == :chronology
    @pl.book_attributes['Call Number'].should     == :call_number
    @pl.book_attributes['Publisher'].should       == :publisher
    @pl.book_attributes['Publisher Place'].should == :publisher_place
    
  end
end