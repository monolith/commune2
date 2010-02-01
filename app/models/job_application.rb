class JobApplication < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
  belongs_to :project

  validates_presence_of     :user
  validates_presence_of     :job

  validates_presence_of     :message
  validates_length_of       :message, :maximum => 1000

  # the logic for these counters should be looked at in tandem with those in the job model
  before_create :custom_counter_cache_after_create
  before_update :custom_counter_cache_before_update
  before_destroy :custom_counter_cache_before_destroy, :update_job_status
  after_save :update_job_status

  def allowed_to_update_application?(user)
    self.user == user ? true : false
  end

  def allowed_to_offer_job?(user)
    if self.project.members.include?(user) or self.project.user == user
      return true
    else
      return false
    end
  end

  def allowed_to_accept_job?(user)
    if self.user == user and self.offered
      return true
    else
      return false
    end
  end

  def allowed_to_fire_or_quit?(user)
    if self.user == user or self.job.user == user or self.project.user == user
      return true
    else
      return false
    end
  end

  private

  # THE BELOW COUNTERS ARE MEANT TO TRACK OPEN JOBS POSTED BY USER
  # AS WELL AS OPEN JOBS FOR A PROJECT
  # whether someone has been hired
  # is taken care of in the job_application model

  def custom_counter_cache_after_create
    if hired and user.active # only counting active users in counter
      update_counters_for_new_hire
    end
  end

  def custom_counter_cache_before_update
    if self.hired_changed? and user.active # only counting active users in counter
      if hired
        # this means the person accepted the job (or otherwise hired)
        update_counters_for_new_hire
      else
        # quit or fired
        update_counters_for_reopened_position
       end
    end
  end

  def custom_counter_cache_before_destroy
    if hired and user.active # if the destroyed applicaction is of a hired user who is active
      update_counters_for_reopened_position
    end
  end

  def update_counters_for_new_hire
    # in case the person is already on this project
    # check if is part of the project
    unless project.members.include? user
      # if the person is already on the project
      # do not increament project or member counters
      # since these were updated the first time the person join the project
      increment_project_members_counter
      # below increases count only if project is active
      # if inactive, the count will be reflected when the project is activated
      # that is covered in the project model
      increment_user_projects_counter if project.active # only if project is active
    end
  end

  def update_counters_for_reopened_position
    # in case the person held more than one position on the project,
    # this check is done
    unless project.filled_positions.count(:conditions => "user_id = " + user.id.to_s) > 1
      # these counters should be decremented only if the person
      # does not hold another position on the project
      decrement_project_members_counter
      # if project is not active, then the user's count would not have included this
      decrement_user_projects_counter if project.active
    end
  end

  def increment_user_projects_counter
    user.scorecard.increment! :active_projects_count
  end

  def decrement_user_projects_counter
    user.scorecard.decrement! :active_projects_count
  end

  def increment_project_members_counter
    # assumes a check has been done to ensure person is not already counted as member
    project.scorecard.increment! :active_members_count
  end

  def decrement_project_members_counter
    # assumes a check has been made to ensure the person is not  member through another job
    project.scorecard.decrement! :active_members_count
  end

  # update job open status

  def update_job_status
    if hired_changed? and job
      if hired
        self.job.update_attribute :open, false
      else
        self.job.update_attribute :open, true
      end
    end
  end


end

