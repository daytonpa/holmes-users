# holmes-users

### Version
1.0.1

### Maintainer
Patrick Dayton

## About

This cookbook installs/configures user and group accounts for your system, and sets up SSH access if desired.  All users,  groups, and user SSH keys are loaded from data bags.

## Usage

There are 3 recipes that are included in the default recipe, but one is included via attribute:
1) `users`
2) `groups`
3) `ssh` *attribute*

Your data bags are accessed via attributes.  You'll need to set those accordingly with the following three attributes via role/override:
1) `default['holmes-users']['data_bag']['users']`
2) `default['holmes-users']['data_bag']['groups']`
3) `default['holmes-users']['data_bag']['credentials']`

Otherwise, SSH configuration options are set through the `node['holmes-users']['ssh_config']` values.  You can view this cookbook's attribute options inside the [default attributes](./attributes/default.rb) file, and can view their corresponding configuration options in the official [ssh_config](https://linux.die.net/man/5/ssh_config) manual page.

## Testing/Linting

This cookbook currently supports unit tests with [ChefSpec](https://docs.chef.io/chefspec.html).  To run ChefSpec, use
```
$ chef exec rspec -fd
```

Linting is performed via [Cookstyle](https://docs.chef.io/cookstyle.html).  To run Cookstyle linting checks, use
```
$ chef exec cookstyle -D .
```
