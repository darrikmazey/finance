# Author: Matthew Tidd
# Date: 02/20/2010
# Description: Custom field class for easily displaying fields from an object
#     in a view.  
# Example: 
#
#   -- helper
#   def custom_fields_for(obj)
#     yield CustomFields.new(obj)
#   end
#
#   -- view code
#   <% custom_fields_for object do |f| %>
#     <%= f.field :database_field %>
#   <% end %>
#
# Using the builder
# -----------------
# - change the helper code above to read
#     def custom_fields_for(obj, options = {})
#       
# - change the view code above to read
#     <% custom_fields_for(object, { :builder => MyFieldBuilder.new }) do |f| %>
#
# - create MyFieldBuilder class
#   class MyFieldBuilder
#     def field(name, value)
#       <<output your html here>>
#     end
#   end

class CustomFields
  attr_accessor :saved_object
  attr_accessor :builder

  # default class for rendering html from the class methods
  class CustomFieldsView
    def field(name, value)
      "<div class\"field_line\"><div class=\"field_label\">#{name} :</div><div class=\"field_value\">#{value}</div></div>"
    end
  end

  # Sets up the custom fields object
  # saved_object = object to use for calling all of the rest of the methods
  # options
  #   - builder = class to use for rendering all of the actual html
  #       allows the developer to use different rendering per field/record
  #       and change the rendering from the default
  def initialize(obj = nil, options = {})
    self.saved_object = obj
    self.builder = CustomFieldsView.new
    if options[:builder]
      if options[:builder].class == Class
        self.builder = options[:builder].new
      else
        self.builder = options[:builder]
      end
    end
  end

  # Displays a field from the saved object with enclosing html
  # function = symbol of the function to call on the saved object
  # options
  #   - default = default value for the field when it's empty (defaults to '&nbsp;')
  #   - label = label for the field (defaults to a stripped version of the function)
  #   - function = function to use if the original value is an array
  #       creates a new CustomFields object and calls field on it with 
  #       this new function for each of the elements of the array
  #   - no_label = flag to not return the enclosing html, just the value.
  #       this is used when the value is an array and the function is set
  #   - object = temporarily use this object instead of the saved object
  #   - builder = temporarily use this builder class instead of the class one
  #   - value = value to use instead of calling the function of the object
  def field(function, options = {})
    # set up the default
    options[:default] = "&nbsp;" unless options[:default]

    # grab the value from the saved object if it's a symbol
    obj = saved_object
    obj = options[:object] if options[:object]
    value = options[:value] || obj.send(function) rescue nil

    # create a logical default for the label or use the option one
    name = function.to_s.gsub('_', ' ').capitalize
    name = options[:label] if options[:label]

    # arrays are handled recursively
    if options[:function]
      function2 = options.delete(:function)
      if value.is_a?(Array)
        c = CustomFields.new
        value = value.collect { |v| 
          c.saved_object = v
          c.field(
            function2, 
            options.merge({:no_label => true}) 
          )
        }.join(", ")
      else
        value = field(function2, options.merge({:no_label => true, :object => value})) if value 
      end
    else
      if value.is_a?(Array)
        value = value.join(", ") 
      end
    end

    value = options[:default] if value == "" || value.nil?
    return "#{value}" if options[:no_label] && options[:no_label] == true
    return self.builder.field(name, value)
  end
end
