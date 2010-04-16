class AddCreatedAtToPicklists < ActiveRecord::Migration
  def self.up
    add_column :picklists, :created_at, :datetime
  end

  def self.down
    remove_column :picklists, :created_at
  end
end
