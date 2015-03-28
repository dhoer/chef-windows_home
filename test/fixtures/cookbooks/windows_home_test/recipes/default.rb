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
