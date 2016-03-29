# Encoding: UTF-8

require_relative '../spec_helper'

describe 'socrata-sensu-client::default::packages' do
  describe package('sensu') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe command('/opt/sensu/embedded/bin/gem list') do
    it 'indicates sensu-plugin is installed' do
      expect(subject.stdout).to match(/^sensu-plugin \(/)
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
      it "indicates the #{p} plugin is installed" do
        expect(subject.stdout).to match(/^sensu-plugins-#{p} \(/)
      end
    end
  end
end
