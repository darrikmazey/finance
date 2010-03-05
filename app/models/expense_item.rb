class ExpenseItem < ActiveRecord::Base

  belongs_to :invoice
  belongs_to :user

  validates_presence_of :invoice_id
  validates_presence_of :user_id

  validates_associated :invoice
  validates_associated :user

  def total_rate
    rate
  end

  def subtotal
    hours * rate
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
