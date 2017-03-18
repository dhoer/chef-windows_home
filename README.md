# Windows Home Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/windows_home.svg?style=flat-square)][cookbook]
[![Build Status](https://img.shields.io/appveyor/ci/dhoer/chef-windows-home/master.svg?style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/windows_home
[win]: https://ci.appveyor.com/project/dhoer/chef-windows-home


Windows Home generates user's home directory (e.g. C:\\Users\\${username}).  This is useful for
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

Generates user's home directory (e.g. C:\\Users\\${username}).

Note the user will have to be created before calling windows_home. If you are not able to create a file
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
