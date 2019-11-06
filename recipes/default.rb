#
# Cookbook:: holmes-users
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

include_recipe 'holmes-users::groups'
include_recipe 'holmes-users::users'
include_recipe 'holmes-users::ssh' if node['holmes-users']['setup_ssh?']
