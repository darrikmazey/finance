class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent
end
