#
# Cookbook:: holmes-users
# Spec:: groups
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'holmes-users::groups' do
  {
    'centos' => PlatformVersions.centos,
  }.each do |platform, platform_versions|
    platform_versions.each do |platform_version|
      context "When all attributes are default, on #{platform.upcase} #{platform_version}" do
        before do
          stub_data_bag('groups').and_return(%w( test-admin test-user ))
          stub_data_bag_item('groups', 'test-admin').and_return(
            id: 'test-admin',
            comment: 'comment'
          )
          stub_data_bag_item('groups', 'test-user').and_return(
            id: 'test-user',
            comment: 'comment'
          )
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version).converge(described_recipe)
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'creates the desired system groups from a data bag' do
          %w( test-admin test-user ).each do |grp|
            expect(chef_run).to create_group(grp).with(
              system: true,
              comment: 'comment'
            )
          end
        end
      end
    end
  end
end
