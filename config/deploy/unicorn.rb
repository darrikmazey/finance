
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

	desc "make unicorn directories"
	task :make_unicorn_dirs, :roles => :app do
		run "cd #{deploy_to} && mkdir -p shared/sockets shared/pids"
	end

	desc "symlink sockets dir"
	task :symlink_sockets_dir, :roles => :app do
		run "cd #{release_path}/tmp && ln -s #{deploy_to}/shared/sockets"
	end
end

after 'deploy:copy_code_to_release', 'unicorn:make_unicorn_dirs'
after 'deploy:symlink_pids_directory', 'unicorn:symlink_sockets_dir'

