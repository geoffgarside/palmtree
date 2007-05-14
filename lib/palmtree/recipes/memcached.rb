Capistrano::Configuration.instance(true).load do
  set :memcached_script, "/etc/init.d/memcached"
  
  namespace :memcached do
    desc <<-DESC
      Starts a memcached server. This will use sudo \
      if it can. In many cases it will be required to \
      use sudo.
    DESC
    task :start do
      run_method "#{memcached_script} start"
    end
    
    desc <<-DESC
      Stops a memcached server. This will use sudo \
      if it can. In many cases it will be required to \
      use sudo.
    DESC
    task :stop do
      run_method "#{memcached_script} stop"
    end
    
    desc <<-DESC
      Restarts a memcached server. This will use sudo \
      if it can. In many cases it will be required to \
      use sudo.
    DESC
    task :restart do
      run_method "#{memcached_script} restart"
    end
  end
end
