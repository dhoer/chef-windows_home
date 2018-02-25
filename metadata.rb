name 'windows_home'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description "Generates user's home directory"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/dhoer/chef-windows_home' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-windows_home/issues' if respond_to?(:issues_url)
chef_version '>= 11.6' if respond_to?(:chef_version)
version '2.0.0'

supports 'windows'
