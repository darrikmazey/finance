class WorkItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :rate
  belongs_to :invoice
end
