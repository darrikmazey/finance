
namespace :deploy do
	
	desc "deploy application"
	task :start, :roles => :app do
	end

	desc "initialize application for deployment"
	task :setup, :roles => :app do
		run "cd #{deploy_to} && mkdir -p releases shared shared/pids"
	end

	desc "clone repository"
	task :setup_code, :roles => :app do
		run "cd #{deploy_to} && git clone #{repository} cache"
	end

	desc "update VERSION"
	task :update_version, :roles => :app do
		run "cd #{deploy_to}/cache && git describe HEAD > ../current/VERSION && cat ../current/VERSION"
	end

	desc "update codebase"
	task :update_code, :roles => :app do
		run "cd #{deploy_to}/cache && git pull"
	end

	desc "make release directory"
	task :make_release_dir, :roles => :app do
		run "mkdir #{release_path}"
	end

	desc "copy code into release folder"
	task :copy_code_to_release, :roles => :app do
		run "cd #{deploy_to}/cache && cp -pR * #{release_path}/"
	end

	desc "run rake:db:migrate"
	task :migrate_db, :roles => :app do
		run "cd #{release_path} && RAILS_ENV=production rake db:migrate"
	end

	desc "restart mongrel"
	task :restart, :roles => :app do
		run "cd #{release_path} && mongrel_rails cluster::restart"
	end

	desc "make tmp directory"
	task :make_tmp_dir, :roles => :app do
		run "cd #{release_path} && mkdir -p tmp"
	end

	desc "symlink pids directory"
	task :symlink_pids_dir, :roles => :app do
		run "cd #{release_path}/tmp && ln -s #{deploy_to}/shared/pids"
	end
end

after 'deploy:setup', 'deploy:setup_code'
after 'deploy:update_code', 'deploy:copy_code_to_release'
before 'deploy:copy_code_to_release', 'deploy:make_release_dir'
after 'deploy:copy_code_to_release', 'deploy:migrate_db'
after 'deploy:symlink', 'deploy:update_version'

before 'deploy:restart', 'deploy:symlink_pids_dir'
before 'deploy:symlink_pids_dir', 'deploy:make_tmp_dir'

namespace :release do
	desc "count releases"
	task :count, :roles => :web do
		run "cd #{deploy_to}/releases && ls -1 | wc -l"
	end

	desc "clean up releases"
	task :clean, :roles => :web do
		keep = variables[:keep] ? variables[:keep] + 1 : 6
		run "cd #{deploy_to}/releases && for i in `ls -1 | sort -rk1 | tail -n +#{keep}`; do echo rm -rf $i; rm -rf $i; done"
	end
end

