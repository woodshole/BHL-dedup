class AddHeaderRowToPicklists < ActiveRecord::Migration
  def self.up
    add_column :picklists, :header_row, :integer
  end

  def self.down
    remove_column :picklists, :header_row
  end
end
