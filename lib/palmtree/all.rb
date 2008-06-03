# Loads all of the Palmtree recipes into your Capfile.
# Normally you would pick and choose the recipes you
# wanted to include.

require 'palmtree/caching/memcached'
require 'palmtree/offloading/backgroundrb'
require 'palmtree/search/ferret'
require 'palmtree/servers/mongrel'
