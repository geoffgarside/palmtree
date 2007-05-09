require 'yaml'

Capistrano::Configuration.instance(true).load do
  set :ferret_host, ''
  set :ferret_port, 9009
  
  namespace :ferret do
    namespace :index do
      desc <<-DESC
      An after_update_code task to symlink release/index to shared/index \
      useful for maintaining a constant ferret index between deployments
      DESC
      task :symlink, :role => :app do
        ferret.index.create
        run <<-CMD
          rm -rf #{release_path}/index &&
          ln -nfs #{shared_path}/index #{release_path}/index
        CMD
      end
  
      desc "Creates the shared/index directory for persistent ferret indexes"
      task :create, :role => :app do
        run "if [ ! -d #{shared_path}/index ]; then mkdir -p #{shared_path}/index ; fi"
      end
      
      desc "Removes the contents of the shared/index directory"
      task :purge, :role => :app do
        run "if [ -d #{shared_path}/index ]; then rm -rf #{shared_path}/index/* ; fi"
      end
    end
  
    namespace :server do
      desc "Configure ferret server"
      task :configure, :role => :app do
        config = {rails_env => {'port' => ferret_port, 'host' => ferret_host, 'pid_file' => "log/ferret-#{rails_env}.pid"}}
        ferret_server_yml = config.to_yaml
    
        run "if [ ! -d #{shared_path}/config ]; then mkdir #{shared_path}/config; fi"
        put(ferret_server_yml, "#{shared_path}/config/ferret_server.yml", :mode => 0644)
      end
  
      desc "Copies the ferret_server.yml file to release_path/config"
      task :copy_config, :role => :app do
        on_rollback {
          puts "***** File shared/config/ferret_server.yml is missing. Make sure you have run configure_ferret first. *****"
        }
    
        run "cp #{shared_path}/config/ferret_server.yml #{release_path}/config/"
      end
  
      desc "Start ferret server"
      task :start, :role => :app do
        run "RAILS_ENV=#{rails_env} #{current_path}/script/runner \"load '#{current_path}/script/ferret_start'\""
      end

      desc "Stop ferret server"
      task :stop, :role => :app do
        run "RAILS_ENV=#{rails_env} #{current_path}/script/runner \"load '#{current_path}/script/ferret_stop'\""
      end
  
      desc "Restart ferret server"
      task :restart, :role => :app do
        ferret.server.stop
        sleep(5)
        ferret.server.start
      end
    end
  end
end
