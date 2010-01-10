class GeneralSkill < ActiveRecord::Base
  validates_presence_of     :name
  validates_uniqueness_of   :name

  has_many :polymorphic_general_skills
  
  attr_accessible  :name, :description

  def self.update_general_skills( args )
  # THIS ENTIRE THING IS REALLY A HACK
  # FOR WHATEVER REASONS VALIDATIONS DO NOT WORK RIGHT
  # THIS IS TO MAKE SURE THAT THE SKILLS DO NOT GET SAVED UNLESS WITHIN RANGE

    object = args[:object]
    skill_ids = args[:skill_ids] || [] # ids should be passed in an array, as integers

    min = 1
    max = 5

    if skill_ids.size >= min and skill_ids.size <= max  # HACK NEED TO CLEAN UP
    # the reason for checking count here is some issue with saving more than 5
    # although the object has a validation to check if more than 5 have been created
    # and saving the object will through an error
    # for some reason general_skills will still be saved
    # this saved even when using a transaction
    
      object.general_skill_ids = skill_ids
      return true # success
    else
      if skill_ids.size < min
        object.errors.add_to_base "At least #{ min } general skill should be selected (but no more than #{ max })"
      else
        object.errors.add_to_base "No more than #{ max } general skills should be selected (but at least 1)"       
      end

      return false # failed
    end

  end


end
