Capistrano::Configuration.instance(true).load do
  set(:log_file) { rails_env }
  
  namespace :tail do
    desc <<-DESC
      Streams a log file. \
      you should set log_file to full path of the log file to tail.
    DESC
    task :file do
      stream "tail -F #{log_file}"
    end
    
    desc <<-DESC
      Streams a log file from shared/log/. \
      you should set log_file to name of the log file to tail.
    DESC
    task :log_file do
      stream "tail -F #{shared_path}/log/#{log_file}.log"
    end
    
    namespace :log do
      desc <<-DESC
        Streams the shared/log/production.log file
      DESC
      task :production , :roles => :app do
        set :log_file, "production"
        tail.log_file
      end
      
      desc <<-DESC
       Streams the shared/log/development.log file
      DESC
      task :development , :roles => :app do
        set :log_file, "development"
        tail.log_file
      end
    end
  end
end
