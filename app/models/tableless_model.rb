# Author : Matthew Tidd
# Date : 2010.02.23
# Description : Provides a way of creating an activerecord model
#     that isn't associated with a database table.
# Usage :
#
# def NewModel < TablelessModel
#   column :some_field, :string
#   column :some_association, :id
# end

class TablelessModel < ActiveRecord::Base
  
  def self.columns
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  # Override the save method to prevent exceptions.
  def save(validate = true)
    validate ? valid? : true
  end
end
