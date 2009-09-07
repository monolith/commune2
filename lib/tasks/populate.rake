
namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    puts "DESTROYING GeneralSkills and Industries..."
    [GeneralSkill, Industry].each(&:destroy_all)
    
    puts "CREATING GeneralSkills..."
    GeneralSkill.populate 30 do |skill|
      skill.name = Populator.words(1..3).titleize
      skill.description = Populator.sentences(2..5)
      puts "Skill: #{skill.name}"
    end

    puts "CREATING Industries..."
    Industry.populate 30 do |industry|
      industry.name = Populator.words(1..3).titleize
      puts "Industry: #{industry.name}"
    end

  end
end



