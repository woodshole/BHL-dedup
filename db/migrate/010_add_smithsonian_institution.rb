class AddSmithsonianInstitution < ActiveRecord::Migration
  def self.up
    Institution.create(:name => 'Smithsonian Libraries')
    
    rsimi = Institution.find_by_name 'Ryan Schenk Institute for the Mentally Insane'
    rsimi.destroy
  end

  def self.down
    sl = Institution.find_by_name 'Smithsonian Libraries'
    sl.destroy
    
    Institution.create (:name => 'Ryan Schenk Institute for the Mentally Insane')
  end
end
