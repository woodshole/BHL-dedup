class Book < ActiveRecord::Base
  belongs_to :picklist
  before_create :format_cells
  
  def self.find_dupes_by_oclc_and_volume(picklist_id)
    sub_select= "SELECT COUNT(*) FROM books AS b1 WHERE books.oclc = b1.oclc AND books.volume = b1.volume"
    find_dupes(sub_select, picklist_id)
  end
  
  def find_dupes_by_oclc_and_volume
    self.class.find(:all,
                    :conditions => ["books.oclc = ? AND books.volume = ? AND books.id != ?", oclc, volume, id], 
                    :include => {:picklist => :institution} )
  end
  
  def self.find_dupes_by_oclc(picklist_id)
    sub_select= "SELECT COUNT(*) FROM books AS b1 WHERE books.oclc = b1.oclc AND books.volume != b1.volume"
    find_dupes(sub_select, picklist_id)
  end
  
  def find_dupes_by_oclc
    self.class.find(:all,
                    :conditions => ["books.oclc = ? AND books.volume != ? AND books.id != ?", oclc, volume, id], 
                    :include => {:picklist => :institution} )
  end

  def self.find_dupes_by_title_and_author(picklist_id)
    sub_select= "SELECT COUNT(*) FROM books AS b1 WHERE books.title = b1.title AND books.author = b1.author AND books.oclc != b1.oclc"
    find_dupes(sub_select, picklist_id)
  end
  
  def find_dupes_by_title_and_author
    self.class.find(:all,
                    :conditions => ["books.title = ? AND books.author = ? AND books.oclc != ? AND books.id != ?", title, author, oclc, id], 
                    :include => {:picklist => :institution} )
  end
  
  def self.find_dupes_by_title_and_chronology(picklist_id)
    sub_select= "SELECT COUNT(*) FROM books AS b1 WHERE books.title = b1.title AND books.chronology = b1.chronology AND books.author != b1.author AND books.oclc != b1.oclc"
    find_dupes(sub_select, picklist_id)
  end
  
  def find_dupes_by_title_and_chronology
    self.class.find(:all,
                    :conditions => ["books.title = ? AND books.chronology = ? AND books.author != ? AND books.oclc != ? AND books.id != ?", title, chronology, author, oclc, id], 
                    :include => {:picklist => :institution} )
  end
  
  def self.find_dupes_by_title(picklist_id)
    sub_select= "SELECT COUNT(*) FROM books AS b1 WHERE books.title = b1.title AND books.author != b1.author AND books.oclc != b1.oclc"
    find_dupes(sub_select, picklist_id)
  end
  
  def find_dupes_by_title
    self.class.find(:all,
                    :conditions => ["books.title = ? AND books.author != ? AND books.oclc != ? AND books.id != ?", title, author, oclc, id], 
                    :include => {:picklist => :institution} )
  end
  
  
  def to_csv
    %("#{internal_identifier}","#{oclc}","#{title}","#{author}","#{volume}","#{chronology}","#{call_number}","#{publisher}","#{publisher_place}")
  end
  
  private
    def self.find_dupes(sub_select, picklist_id)
      find_by_sql( ["SELECT books.* FROM books " + 
                    "WHERE picklist_id = ? " + 
                    "AND 1 < (#{sub_select})",
                    picklist_id] )
    end
    
    def format_cells

      attributes.each do |name, value|
        value.strip! if value.respond_to? :strip

        case name.to_sym
        when :title
          value.gsub! /\.$/, '' rescue nil
          value.rstrip!         rescue nil
        else
        end

      end

    end
end
