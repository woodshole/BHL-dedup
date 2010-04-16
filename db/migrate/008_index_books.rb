class IndexBooks < ActiveRecord::Migration
  def self.up
    add_index :books, :oclc
    add_index :books, :title
    add_index :books, :author
  end

  def self.down
    remove_index :books, :oclc
    remove_index :books, :title
    remove_index :books, :author
  end
end
