require 'yaml'

Capistrano::Configuration.instance(true).load do
  set :backgroundrb_host, 'localhost'
  set :backgroundrb_port, 2000
  set :backgroundrb_env, 'production'
  
  namespace :backgroundrb do
    desc "Uses 'set' variables in deploy.rb to write the shared/config/backgroundrb.yml file"
    task :configure, :role => :app do
      config = {:host => backgroundrb_host, :port => backgroundrb_port, :rails_env => backgroundrb_env}
      backgroundrb_yml = config.to_yaml
    
      run "if [ ! -d #{shared_path}/config ]; then mkdir #{shared_path}/config; fi"
      put(backgroundrb_yml, "#{shared_path}/config/backgroundrb.yml", :mode => 0644)
    end

    desc "Stops the backgroundrb server."
    task :stop, :role => :app do
      run "#{current_path}/script/backgroundrb stop"
    end
  
    desc "Starts the backgroundrb server."
    task :start, :role => :app do
      run "#{current_path}/script/backgroundrb start"
    end
  
    desc "Restarts a running backgroundrb server."
    task :restart, :role => :app do
      backgroundrb.stop
      sleep(5)  # sleep for 5 seconds to make sure the server has mopped up everything
      backgroundrb.start
    end
  
    desc "Copies the shared/config/backgroundrb yaml to release/config/"
    task :copy_config, :role => :app do
      on_rollback {
        puts "***** File shared/config/backgroundrb.yml is missing. Make sure you have run backgroundrb:configure first. *****"
      }
    
      run "cp #{shared_path}/config/backgroundrb.yml #{release_path}/config/"
    end
  end
end
