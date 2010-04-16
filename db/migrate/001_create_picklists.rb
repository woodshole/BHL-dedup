class CreatePicklists < ActiveRecord::Migration
  def self.up
    create_table :picklists do |t|
      t.column :institution_id, :integer
      t.column :content_type, :string
      t.column :size, :integer
      t.column :filename, :string
    end
  end

  def self.down
    drop_table :picklists
  end
end
