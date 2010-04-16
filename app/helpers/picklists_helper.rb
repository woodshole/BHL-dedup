module PicklistsHelper
  def row_preview(picklist, form, max_row)
    output = ''
    picklist.rows.each_with_index do |row, r|
      break unless r < max_row
      # c = 0
      output << %Q(<tr class="row#{r} #{'col_header' if r == picklist.header_row}">\n<td class="gutter">#{r}</td>\n)
      
      picklist.max_cols.times do |c|
        if row && cell = row[c]
          contents = h cell.to_s('UTF-8')
          if r == picklist.header_row
            contents << header_selector(picklist, form, c)
          end
        else
          contents = ''
        end
        output << <<-HTML
         <td id="r#{r}c#{c}" class="col#{c}">#{contents}</td>
         HTML
      end
    
      output << '</tr>'
    end
    output
  end
  
  def header_selector(picklist, form, col_num)
    #form.select("inverted_header_map_#{col_num}", options_for_header_select(picklist))
    selected_item = picklist.inverted_header_map[col_num.to_s].to_sym rescue nil
        
    select_tag("picklist[inverted_header_map][#{col_num}]",
               options_for_select(options_for_header_select(picklist),
               selected_item))
    
  end
  
  def options_for_header_select(picklist)
    #@options_for_header_select ||= [['-- ignore --', nil]] + picklist.header_map.keys.collect {|key| [key.to_s.humanize.titleize, key]}
    @options_for_header_select ||= [['-- ignore --', nil]] + Picklist::PLATONIC_IDEAL_COLS.collect {|key| [key.to_s.humanize.titleize, key]}
  end
end
