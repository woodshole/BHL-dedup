require 'parseexcel'

class Picklist < ActiveRecord::Base
  belongs_to :institution
  has_many   :books, :dependent => :destroy do
    def find_dupes(range)
      finder_method = "find_dupes_by_#{range.to_s}".to_sym
      if Book.respond_to? finder_method
        send finder_method, proxy_owner.id
      else
        raise ArgumentError, "Does not accept #{range.to_s}", caller
      end
    end
  end
  
  serialize :header_map
  
  before_create :write_books_to_db
  
  has_attachment :content_type => ['application/vnd.ms-excel', 'application/octet-stream'],
                 :storage      => :file_system,
                 :max_size     => 5.megabytes,
                 :path_prefix  => 'public/picklist_uploads'
  
  ROWS_TO_PREVIEW = 10
  VALID_COLUMNS   = ["Local Number","OCLC","Title","Author","Volume","Chronology","Call Number","Publisher","Publisher Place"]
  
  attr_reader   :max_cols

  def to_csv
    quoted_column_headers = VALID_COLUMNS.map{|c| "\"#{c}\"" }.join(',')
    csv = [quoted_column_headers]
    books.each{|b| csv << b.to_csv }
    csv.join("\n")
  end
  
  def base_filename
    @base_filename ||= filename.chomp(File.extname(filename))
  end
  
  # converts VALID_COLUMNS from strings to symbols that match the columns in the books table
  def book_attributes
    @book_attributes ||= VALID_COLUMNS.to_hash_keys do |valid_column_name|
      valid_column_name = "Internal Identifier" if valid_column_name == "Local Number"
      valid_column_name.tr(' ', '').underscore.to_sym
    end
  end
  
  def rows
    parse if @worksheet.nil?
    @worksheet
  end
  
  def validate
    parse
      
    valid = true
    header_map.each do |col_header, col_number|
      if col_number.nil?
        valid = false
        errors.add_to_base "Missing the \"#{col_header.to_s.humanize.titleize}\" column."
      end
    end
    return valid
    
  rescue OLE::UnknownFormatError
    errors.add_to_base "Could not read #{filename}. Are you sure it is an XLS document?"
    return false  
  end
  
  private  
    def parse
      if @worksheet.blank?    
        start_time  = Time.now
        @workbook   = Spreadsheet::ParseExcel.parse(temp_path) #full_filename)
        end_time    = Time.now
        @worksheet  = @workbook.worksheet 0

        guestimate_column_header_row
        map_column_headers
      end 
    end
    
    def write_books_to_db      
      first_line_of_data = header_row + 1
      map = read_attribute(:header_map)
      
      (first_line_of_data...rows.num_rows).each do |r|
        book_attrs = {}
        VALID_COLUMNS.each do |col_name|
          book_attr = book_attributes[col_name] # converts "Publisher Place" to :publisher_place, etc
          c = map[col_name].to_i                # converts "Publisher Place" to the integer of the column where the publisher place is located in the XLS
          book_attrs[book_attr] = rows.cell(r, c).to_s('UTF-8')
        end

        books.build(book_attrs) unless book_attrs.values.all?{|v| v.blank? } # Sometimes we get rows that are all blank.
      end
    end
  
    def guestimate_column_header_row
      num_headers = VALID_COLUMNS.length # The number of column headers we have
      @max_cols ||= 0
      found_header = false
      write_attribute(:header_row, 0)
      
      rows.each_with_index do |row, r|
        break unless r < ROWS_TO_PREVIEW
        if row
          @max_cols = row.length if row.length > @max_cols
          if !found_header && row.length >= num_headers
            write_attribute(:header_row, r)
            found_header = true
            #break
          end
        end
      end
    end
    
    # header_map maps the column name to its column index in the file
    def map_column_headers
      map = VALID_COLUMNS.to_hash_keys { |k| nil }
      logger.debug "DEBUG: header_row is #{header_row}"
      headers = rows[header_row]
      headers.each_with_index do |cell,index|
        if cell
          header_value = cell.to_s('UTF-8').downcase
          map.each do |k, v|
            key = k.to_s.humanize.downcase
            if map[k].nil? && key == header_value
              map[k] = index.to_i
              break
            end
          end
        end
      end
      write_attribute :header_map, map
    end
end
