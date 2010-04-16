class AddPicklistIdToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :picklist_id, :integer
  end

  def self.down
    remove_column :books, :picklist_id
  end
end
