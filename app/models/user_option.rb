class UserOption < TablelessModel
  column :account_group_id, :id
  column :user_id, :id
  column :template, :string

  belongs_to :user
  belongs_to :account_group

  # make sure the template exists and is valid
  def template
    tem = self.read_attribute('template') 
    tem = UserOption.templates.first unless tem
    tem = UserOption.templates.first unless UserOption.templates.include?(tem)
    self.write_attribute('template', tem)
    return tem
  end

  # get the list of templates from the template folder
  def self.templates
    if !@user_option_templates
      Dir.chdir("#{RAILS_ROOT}/public/stylesheets/templates/")
      @user_option_templates = Dir['*.css'].collect { |c| c.gsub('.css', '') }
    end
    return @user_option_templates
  end
end
