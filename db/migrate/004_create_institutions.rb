class CreateInstitutions < ActiveRecord::Migration
  def self.up
    create_table :institutions do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :institutions
  end
end
