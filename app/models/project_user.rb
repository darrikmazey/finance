class ProjectUser < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :project_id

  belongs_to :user
  belongs_to :project

  validates_associated :user
  validates_associated :project
end
