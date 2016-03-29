# Encoding: UTF-8
#
# Cookbook Name:: socrata-sensu-client
# Recipe:: default
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'socrata-sensu'

sensu_gem 'sensu-plugin' do
  version node['socrata_sensu_client']['sensu_plugin_version']
end

%w(
  sensu-plugins-cpu-checks
  sensu-plugins-disk-checks
  sensu-plugins-http
  sensu-plugins-load-checks
  sensu-plugins-logs
  sensu-plugins-memory-checks
  sensu-plugins-network-checks
  sensu-plugins-postfix
  sensu-plugins-process-checks
  sensu-plugins-filesystem-checks
).each do |g|
  sensu_gem g
end

if node['ec2']
  package 'libxml2-dev'
  package 'zlib1g-dev'
  sensu_gem 'sensu-plugins-aws'
end
