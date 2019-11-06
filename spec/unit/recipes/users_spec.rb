#
# Cookbook:: holmes-users
# Spec:: users
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'holmes-users::users' do
  {
    'centos' => PlatformVersions.centos,
  }.each do |platform, platform_versions|
    platform_versions.each do |platform_version|
      context "When all attributes are default, on #{platform.upcase} #{platform_version}" do
        before do
          stub_data_bag('users').and_return(%w( test-admin test-user ))
          stub_data_bag_item('users', 'test-admin').and_return(
            id: 'test-admin',
            manage_home: true,
            sudoer: true
          )
          stub_data_bag_item('users', 'test-user').and_return(
            id: 'test-user',
            manage_home: true,
            sudoer: false
          )
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version).converge(described_recipe)
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        it 'creates the desired system users from a data bag' do
          %w( test-admin test-user ).each do |usr|
            expect(chef_run).to create_user(usr).with(
              system: true,
              manage_home: true
            )
          end
        end
        it 'adds the user to the root group if sudoer is set to true' do
          expect(chef_run).to modify_group('root').with(
            members: %w(test-admin)
          )
          expect(chef_run).to_not modify_group('root').with(
            members: %w(test-user)
          )
        end
      end
    end
  end
end
