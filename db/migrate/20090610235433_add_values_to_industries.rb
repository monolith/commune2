class AddValuesToIndustries < ActiveRecord::Migration
  def self.up
    Industry.create :name => "Just for fun"
    Industry.create :name => "Saving the planet"
    Industry.create :name => "Human betterment"
    Industry.create :name => "Commune2 enhancement"


  end

  def self.down
    Industry.find_by_name("Just for fun").delete
    Industry.find_by_name("Saving the planet").delete
    Industry.find_by_name("Human betterment").delete
    Industry.find_by_name("Commune2 enhancement").delete
  
  end
end
