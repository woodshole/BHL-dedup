class AddHeaderMappingToPicklists < ActiveRecord::Migration
  def self.up
    add_column :picklists, :header_map, :text
  end

  def self.down
    remove_column :picklists, :header_map
  end
end
