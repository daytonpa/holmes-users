#
# Cookbook:: holmes-users
# Recipe:: groups
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Load our data bag groups
group_items = data_bag(node['holmes-users']['data_bag']['groups'])

# Create them
group_items.each do |item|
  group_item = data_bag_item(node['holmes-users']['data_bag']['groups'], item)
  group group_item['id'] do
    comment group_item['description']
    system true
  end
end
