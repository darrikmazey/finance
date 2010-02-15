class Comment < ActiveRecord::Base
  belongs_to :work_item
	has_one :user, :through => :work_item
end
