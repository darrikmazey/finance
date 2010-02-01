
namespace :unicorn do
	desc "restart unicorn"
	task :restart, :roles => :app do
		run "sudo /usr/local/bin/unicorn_restart #{application} || sudo /etc/init.d/unicorn start"
	end

	desc "autostart site"
	task :autostart, :roles => :app do
		run "cd /etc/unicorn/sites && sudo ln -s #{deploy_to}/current #{application}"
	end

	desc "no autostart"
	task :no_autostart, :roles => :app do
		run "sudo rm -f /etc/unicorn/sites/#{application}"
	end
end

