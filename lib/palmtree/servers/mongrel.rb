Capistrano::Configuration.instance(true).load do
  set :mongrel_servers, 2
  set :mongrel_port, 8000
  set :mongrel_address, "127.0.0.1"
  set :mongrel_environment, "production"
  set :mongrel_conf, nil
  set :mongrel_user, nil
  set :mongrel_group, nil
  set :mongrel_prefix, nil
  
  namespace :mongrel do
    namespace :cluster do
      desc <<-DESC
      Configure Mongrel processes on the app server. This uses the :use_sudo
      variable to determine whether to use sudo or not. By default, :use_sudo is
      set to true.
      DESC
      task :configure, :roles => :app do
        set_mongrel_conf
        
        argv = []
        argv << "mongrel_rails cluster::configure"
        argv << "-N #{mongrel_servers.to_s}"
        argv << "-p #{mongrel_port.to_s}"
        argv << "-e #{mongrel_environment}"
        argv << "-a #{mongrel_address}"
        argv << "-c #{current_path}"
        argv << "-C #{mongrel_conf}"
        argv << "--user #{mongrel_user}" if mongrel_user
        argv << "--group #{mongrel_group}" if mongrel_group
        argv << "--prefix #{mongrel_prefix}" if mongrel_prefix
        cmd = argv.join " "
        send(run_method, cmd)
      end
  
      desc <<-DESC
      Start Mongrel processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
      set to true.
      DESC
      task :start , :roles => :app do
        set_mongrel_conf
        send(run_method, "mongrel_rails cluster::start -C #{mongrel_conf}")
      end
  
      desc <<-DESC
      Restart the Mongrel processes on the app server by starting and stopping the cluster. This uses the :use_sudo
      variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
      DESC
      task :restart , :roles => :app do
        set_mongrel_conf
        send(run_method, "mongrel_rails cluster::restart -C #{mongrel_conf}")
      end
  
      desc <<-DESC
      Stop the Mongrel processes on the app server.  This uses the :use_sudo
      variable to determine whether to use sudo or not. By default, :use_sudo is
      set to true.
      DESC
      task :stop , :roles => :app do
        set_mongrel_conf
        send(run_method, "mongrel_rails cluster::stop -C #{mongrel_conf}")
      end
  
      def set_mongrel_conf
        set :mongrel_conf, "etc/mongrel_cluster/#{application}.yml" unless mongrel_conf
      end
    end
  end
  
  # We need to override the core deployment tasks so they use mongrel cluster instead.
  namespace :deploy do
    desc <<-DESC
    Restart the Mongrel processes on the app server by calling mongrel:cluster:restart.
    DESC
    task :restart, :roles => :app, :except => { :no_release => true } do
      mongrel.cluster.restart
    end
    
    desc <<-DESC
      Start the application servers. Calls mongrel:cluster:start.
    DESC
    task :start, :roles => :app do
      mongrel.cluster.start
    end
    
    desc <<-DESC
      Stop the application servers. Calls mongrel:cluster:stop.
    DESC
    task :stop, :roles => :app do
      mongrel.cluster.stop
    end
  end
end