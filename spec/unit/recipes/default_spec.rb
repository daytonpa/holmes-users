#
# Cookbook:: holmes-users
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'holmes-users::default' do
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
          stub_data_bag_item('users', 'test-admin').and_return(id: 'test-admin')
          stub_data_bag_item('users', 'test-user').and_return(id: 'test-user')
          stub_data_bag_item('credentials', 'test-admin').and_return(id: 'test-admin', ssh_public_key: 'ssh-rsa abcde')
          stub_data_bag_item('credentials', 'test-user').and_return(id: 'test-user', ssh_public_key: 'ssh-rsa fghij')
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version).converge(described_recipe)
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'includes the default "users" and "groups" recipes' do
          %w( users groups ).each do |recipe|
            expect(chef_run).to include_recipe("holmes-users::#{recipe}")
          end
        end
        it 'does not setup remote SSH access' do
          expect(chef_run).to_not include_recipe('holmes-users::ssh')
        end
      end
      context "When set to configure remote SSH access, on #{platform} #{platform_version}" do
        before do
          stub_data_bag('groups').and_return(%w( test-admin test-user ))
          stub_data_bag('users').and_return(%w( test-admin test-user ))
          stub_data_bag('credentials').and_return(%w( test-admin test-user ))
          stub_data_bag_item('groups', 'test-admin').and_return(id: 'test-admin')
          stub_data_bag_item('groups', 'test-user').and_return(id: 'test-user')
          stub_data_bag_item('users', 'test-admin').and_return(id: 'test-admin')
          stub_data_bag_item('users', 'test-user').and_return(id: 'test-user')
          stub_data_bag_item('credentials', 'test-admin').and_return(id: 'test-admin', ssh_public_key: 'ssh-rsa abcde')
          stub_data_bag_item('credentials', 'test-user').and_return(id: 'test-user', ssh_public_key: 'ssh-rsa fghij')
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version) do |node|
            node.normal['holmes-users']['setup_ssh?'] = true
          end.converge(described_recipe)
        end
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'includes the "ssh" recipe' do
          expect(chef_run).to include_recipe('holmes-users::ssh')
        end
      end
    end
  end
end
