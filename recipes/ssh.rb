#
# Cookbook:: holmes-users
# Recipe:: ssh
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Load our users
system_users = data_bag(node['holmes-users']['data_bag']['users'])

system_users.each do |user|
  system_user = data_bag_item(node['holmes-users']['data_bag']['users'], user)
  credentials = data_bag_item(node['holmes-users']['data_bag']['credentials'], user)

  # Create an SSH directory for the user
  directory "#{system_user['home']}/.ssh" do
    owner system_user['id']
    group system_user['gid']
    mode '0700'
  end

  # Add our user's public SSH key
  file "#{system_user['home']}/.ssh/authorized_keys" do
    owner system_user['id']
    group system_user['gid']
    mode '0640'
    content credentials['ssh_public_key']
  end
end

# Update the global SSH configuration file
template '/etc/ssh/ssh_config' do
  source 'ssh_config.erb'
  notifies :restart, 'service[sshd]', :immediately
end

# Service already exists.  Use resource as a placeholder for SSH config
# updates
service 'sshd' do
  action :nothing
end
