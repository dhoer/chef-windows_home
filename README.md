# Windows Home Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_home.svg?style=flat-square)][cookbook]
[![Build Status](https://img.shields.io/appveyor/ci/dhoer/chef-windows-home/master.svg?style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_home
[win]: https://ci.appveyor.com/project/dhoer/chef-windows-home


Windows Home generates user's home directory (e.g. `C:\\Users\\${username}`).  This is useful for
when you need access to directories like Documents or AppData after creating a user.

Tested on Amazon Windows Server 2012 R2 AMI.

## Requirements

- Chef 11.6.0 or higher
- Windows Server 2008 R2 or higher due to its API usage

## Platforms

- Windows

## Usage

Include `windows_home` as a dependency to use resource.

### windows_home

Generates user's home directory (e.g. `C:\\Users\\${username}`).

Note the user will have to be created before calling `windows_home`. If you are not able to create a file
under home directory, then make sure you have the appropriate group permissions.

#### Actions

- `create` - Creates and populates the user's home directory.

#### Attributes

- `username` - Username of account to create and populate home directory
for. Defaults to name of the resource block.
- `password` - The password of the user (required).
- `confidential` - Ensure that sensitive resource data is not logged by
the chef-client. Default: `true`.

#### Example

```ruby
user 'newuser' do
  password 'N3wPassW0Rd'
end

group 'Administrators' do
  members ['newuser']
  append true
  action :modify
end

windows_home 'newuser' do
  password 'N3wPassW0Rd'
end
```

### Known Issues
In order to run the scheduled task as the target user and force home creation, the target user needs to have the ["Log on as a batch job" (`SeBatchLogonRight`) right](https://technet.microsoft.com/en-us/library/cc957131.aspx).


The chef user *may* also need the "Replace a process level token"(`SeAssignPrimaryTokenPrivilege`) right.

You can try to grant these rights in your chef recipe, but I've personally found that chef will intermittently throw exceptions in the `get_account_right` checks:
```ruby
target_user = 'newuser'
ruby_block "Give #{target_user} SeBatchLogonRight right" do
  block { Chef::ReservedNames::Win32::Security.add_account_right(target_user, right) }
  action :run
  not_if { Chef::ReservedNames::Win32::Security.get_account_right(target_user).include?(right) }
end

# Grant chef user "Replace a process level token" right
ruby_block "Give #{ENV['USERNAME']} SeAssignPrimaryTokenPrivilege right" do
  block { Chef::ReservedNames::Win32::Security.add_account_right(ENV['USERNAME'], right) }
  action :run
  not_if { Chef::ReservedNames::Win32::Security.get_account_right(ENV['USERNAME']).include?(right) }
end
```

Please also note that though this recipe will generate the user home directory, you may still experience unexpected behavior trying to do some other thinsg with this user. For example, setting user-level environment variables via `SETX` execution as the target user appeared to succeed but ended up getting set up in the registry for the wrong user SID. Only a restart with auto-logon for the target user fixed that behavior.

It may be more beneficial to use tools that can handle the need for restarts and continue running. For example, [test-kitchen now supports continuing to converge after reboots](https://discourse.chef.io/t/test-kitchen-1-10-0-released/8721) with modifications to your `.kitchen.yml`.

I've found it helpful in my usage to pair up generating a target user, then [setting up auto-logon for that user](https://github.com/dhoer/chef-windows_autologin) and forcing a reboot; with test-kitchen and my deploy process capable of continuing the converge process after a reboot exit code (`35`).

## ChefSpec Matchers

The Chrome cookbook includes a custom [ChefSpec](https://github.com/sethvargo/chefspec) matcher you can use to test your
own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to create_windows_home('username').with(
  password: 'N3wPassW0Rd'
)
```

Windows Home Cookbook Matcher

- create_windows_home(username)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/windows+user).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-windows_home/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-windows_home/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-windows_home/blob/master/LICENSE.md) file for
details.
