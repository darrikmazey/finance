set :application, "finance"
set :repository,  "git.darmasoft.com:/git/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
ssh_options[:keys] = ['~/.ssh/capuser_darmasoft_com-id_rsa']
set :scm_username, 'gituser'
set :user, 'capuser'

role :app, "finance.darmasoft.net"
role :web, "finance.darmasoft.net"
role :db,  "finance.darmasoft.net", :primary => true

load 'config/deploy/global'

