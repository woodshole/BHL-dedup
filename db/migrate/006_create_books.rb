class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.column :oclc, :integer
      t.column :internal_identifier, :string
      t.column :volume, :string
      t.column :chronology, :string
      t.column :call_number, :string
      t.column :author, :string
      t.column :publisher_place, :string
      t.column :publisher, :string
      t.column :title, :string
    end
  end

  def self.down
    drop_table :books
  end
end
