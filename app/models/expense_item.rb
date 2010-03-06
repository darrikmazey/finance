class ExpenseItem < ActiveRecord::Base

  belongs_to :invoice
  belongs_to :user
  belongs_to :project

  validates_presence_of :project_id
  validates_presence_of :user_id

  validates_associated :project
  validates_associated :user

  named_scope :loose, { :conditions => { :invoice_id => nil } }
  named_scope :ascending_creation, { :order => 'created_at asc' }

  def invoice_start_time
    updated_at
  end

  def total_rate
    rate
  end

  def subtotal
    hours * rate
  end

  def start_time
    ''
  end

  def end_time
    ''
  end

  # make this act like work_items
  def comments
    [ExpenseItemComment.new(self.description)]
  end  

  # looks like a work item comment to me ...
  class ExpenseItemComment
    attr_accessor :body

    def initialize(text)
      self.body = text
    end 
  end
end
