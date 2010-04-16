class AddTestInstitutions < ActiveRecord::Migration
  def self.up
    Institution.create( [ {:name => 'Marine Biological Laboratory'},
                          {:name => 'Ryan Schenk Institute for the Mentally Insane'} ])
  end

  def self.down
    mbl = Institution.find_by_name 'Marine Biological Laboratory'
    mbl.destroy
    
    rsimi = Institution.find_by_name 'Ryan Schenk Institute for the Mentally Insane'
    rsimi.destroy
  end
end
