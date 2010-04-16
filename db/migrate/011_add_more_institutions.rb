class AddMoreInstitutions < ActiveRecord::Migration
  def self.up 
    Institution.create([ {:name => 'American Museum of Natural History, New York'},
                         {:name => 'The Field Museum'},
                         {:name => 'Harvard University Botany Libraries'},
                         {:name => 'Ernst Mayr Library of the Museum of Comparative Zoology'},
                         {:name => 'Missouri Botanical Garden'},
                         {:name => 'Natural History Museum, London'},
                         {:name => 'The New York Botanical Garden'},
                         {:name => 'Royal Botanic Garden, Kew'},
                         {:name => 'Smithsonian Institution Libraries'}
                      ])
    
    rsimi = Institution.find_by_name 'Smithsonian Libraries'
    rsimi.destroy
  end

  def self.down  
    [ {:name => 'American Museum of Natural History, New York'},
      {:name => 'The Field Museum'},
      {:name => 'Harvard University Botany Libraries'},
      {:name => 'Ernst Mayr Library of the Museum of Comparative Zoology'},
      {:name => 'Missouri Botanical Garden'},
      {:name => 'Natural History Museum, London'},
      {:name => 'The New York Botanical Garden'},
      {:name => 'Royal Botanic Garden, Kew'},
      {:name => 'Smithsonian Institution Libraries'}
    ].each do |institution|
      record = Institution.find_by_name institution[:name]
      record.destroy
    end
    
    Institution.create (:name => 'Smithsonian Libraries')
  end
end
