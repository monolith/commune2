class AddCountersToScorecard < ActiveRecord::Migration
  def self.up

    add_column :scorecards, :total_comments_count, :integer, :default => 0
    add_column :scorecards, :active_ideas_count, :integer, :default => 0
    add_column :scorecards, :active_projects_count, :integer, :default => 0
    add_column :scorecards, :active_jobs_count, :integer, :default => 0
    add_column :scorecards, :active_members_count, :integer, :default => 0


    Idea.all.each do |idea|
      idea.scorecard.total_comments_count = idea.comments.count
      idea.scorecard.active_projects_count = idea.projects.count :conditions => "projects.active"
      idea.scorecard.save(false)
    end
    
    Project.all.each do |project|
      project.scorecard.total_comments_count = project.comments.count
      project.scorecard.active_jobs_count = project.jobs.count :conditions => "jobs.active and jobs.open"
      project.scorecard.active_members_count = project.members.count
      project.scorecard.save(false)
    end

    User.all.each do |user|
      user.scorecard.total_comments_count = user.comments.count
      user.scorecard.active_ideas_count = user.ideas.count :conditions => "ideas.active"
      user.scorecard.active_projects_count = user.active_projects.count
      user.scorecard.active_jobs_count = user.jobs.count :conditions => "jobs.active and jobs.open"
      user.scorecard.save(false)
    end

  end

  def self.down
    remove_column :scorecards, :total_comments_count
    remove_column :scorecards, :active_ideas_count
    remove_column :scorecards, :active_projects_count
    remove_column :scorecards, :active_jobs_count
    remove_column :scorecards, :active_members_count

  end
end
