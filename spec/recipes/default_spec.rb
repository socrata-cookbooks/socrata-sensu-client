# Encoding: UTF-8

require_relative '../spec_helper'

describe 'socrata-sensu-client::default' do
  let(:ec2) { nil }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      node.set['ec2'] = ec2
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any platform' do
    it 'installs Sensu' do
      expect(chef_run).to include_recipe('socrata-sensu')
    end

    it 'installs the sensu-plugin gem' do
      expect(chef_run).to install_sensu_gem('sensu-plugin')
        .with(version: '1.2.0')
    end

    %w(
      cpu-checks
      disk-checks
      http
      load-checks
      logs
      memory-checks
      network-checks
      postfix
      process-checks
      filesystem-checks
    ).each do |p|
      it "installs the #{p} plugin" do
        expect(chef_run).to install_sensu_gem("sensu-plugins-#{p}")
      end
    end
  end

  context 'a non-EC2 server' do
    let(:ec2) { nil }

    it_behaves_like 'any platform'

    it 'does not install the aws plugin' do
      expect(chef_run).to_not install_package('libxml2-dev')
      expect(chef_run).to_not install_package('zlib1g-dev')
      expect(chef_run).to_not install_sensu_gem('sensu-plugins-aws')
    end
  end

  context 'an EC2 server' do
    let(:ec2) { true }

    it_behaves_like 'any platform'

    it 'installs the aws plugin' do
      expect(chef_run).to install_package('libxml2-dev')
      expect(chef_run).to install_package('zlib1g-dev')
      expect(chef_run).to install_sensu_gem('sensu-plugins-aws')
    end
  end
end
