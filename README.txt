README for palmtree
===================

Capistrano 2.0 recipes.

Usage
=====
In your capistrano deploy.rb file add

  require 'palmtree/recipes'

to add the default recipes such as `tail`. If you want to use the Ferret,
backgrounDRb or MemCached recipes these need to be explicitly required using

  require 'palmtree/recipes/ferret'
  require 'palmtree/recipes/memcached'
  require 'palmtree/recipes/backgroundrb'

respectively.

