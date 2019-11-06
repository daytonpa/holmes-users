#
# Cookbook:: holmes-users
# Recipe:: users
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Grab our users data bag
system_users = data_bag(node['holmes-users']['data_bag']['users'])
system_users.each do |item|
  # Load a user
  system_user = data_bag_item(node['holmes-users']['data_bag']['users'], item)

  # Create the user
  user system_user['id'] do
    comment system_user['description']
    gid system_user['gid']
    manage_home true
    home system_user['home']
    shell system_user['shell']
    system true
  end

  # Give them the power?
  next unless system_user['sudoer']
  group 'root' do
    members %W( #{system_user['id']} )
    action :modify
  end
end
