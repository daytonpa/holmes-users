#
# Cookbook:: holmes-users
# Spec:: ssh
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'holmes-users::ssh' do
  {
    'centos' => PlatformVersions.centos,
  }.each do |platform, platform_versions|
    platform_versions.each do |platform_version|
      context "When all attributes are default, on #{platform.upcase} #{platform_version}" do
        before do
          stub_data_bag('groups').and_return(%w( test-admin test-user ))
          stub_data_bag('users').and_return(%w( test-admin test-user ))
          stub_data_bag('credentials').and_return(%w( test-admin test-user ))
          stub_data_bag_item('groups', 'test-admin').and_return(id: 'test-admin')
          stub_data_bag_item('groups', 'test-user').and_return(id: 'test-user')
          stub_data_bag_item('users', 'test-admin').and_return(id: 'test-admin', home: '/home/test-admin')
          stub_data_bag_item('users', 'test-user').and_return(id: 'test-user', home: '/home/test-user')
          stub_data_bag_item('credentials', 'test-admin').and_return(id: 'test-admin', ssh_public_key: 'ssh-rsa abcde')
          stub_data_bag_item('credentials', 'test-user').and_return(id: 'test-user', ssh_public_key: 'ssh-rsa fghij')
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version).converge(described_recipe)
        end
        let(:template_ssh) { chef_run.template('/etc/ssh/ssh_config') }

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'creates ssh directories for each data bag user' do
          %w( test-admin test-user ).each do |usr|
            expect(chef_run).to create_directory("/home/#{usr}/.ssh").with(
              owner: usr
            )
          end
        end
        it 'creates the authorized_keys file for each data bag user' do
          %w( test-admin test-user ).each do |usr|
            expect(chef_run).to create_file("/home/#{usr}/.ssh/authorized_keys").with(
              owner: usr
            )
          end
        end
        it 'updates the global ssh_config file' do
          expect(chef_run).to create_template('/etc/ssh/ssh_config').with(
            source: 'ssh_config.erb'
          )
        end
        it 'restarts the \'ssh\' service' do
          expect(template_ssh).to notify('service[sshd]').to(:restart).immediately
        end
      end
    end
  end
end
