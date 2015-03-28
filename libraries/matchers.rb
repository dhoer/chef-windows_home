if defined?(ChefSpec)
  def create_windows_home(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_home, :create, resource_name)
  end
end
