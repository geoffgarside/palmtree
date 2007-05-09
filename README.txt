README for palmtree
===================

This project contains Capistano 1.4 and 2.0 recipes for Ferret and BackgrounDRb.

Mongrel Cluster Recipes
=======================
This project also includes recipes for Mongrel Cluster. This will be done until the RailsMachine 
project releases its own set of recipes for Mongrel Cluster and Capistrano 2.0.

BackgrounDRb Recipes
====================
The basic tasks of start, stop and restart are provided within the BackgrounDRb recipes. Additionally 
you can also include some configuration parameters in your deploy.rb file which will be written to the 
shared_path/config/backgroundrb.yml file. There is an additional task to copy this file into the 
release_path/config/ directory as part of a deploy:after_update_code task.

  * backgroundrb:start       - Start the backgroundrb server
  * backgroundrb:stop        - Stop the backgroundrb server
  * backgroundrb:restart     - Restart the backgroundrb server, includes a 5 second delay.

Additionally the following two tasks are related to the shared_path/config/backgroundrb.yml file

  * backgroundrb:configure   - Writes the configuration YAML file from the variables in deploy.rb
  * backgroundrb:copy_config - Copies the shared_path/config/backgroundrb.yml file to the release_path.

The following variables are related to these tasks

  * :backgroundrb_host       - Hostname or IP of backgroundrb server. Default (localhost).
  * :backgroundrb_port       - Port which the backgroundrb server is listening on. Default (2000).
  * :backgroundrb_env        - Rails environment to load. Default (production).

ACLs are something which may be added in the future.

Ferret Server Recipes
=====================
These are really beta level at the moment. Includes configuration, start, stop and restart tasks. It 
will also include tasks related to the ferret index. Tasks would include reindex and clear.
