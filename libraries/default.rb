def home_dir(username)
  ::File.join(ENV['SYSTEMDRIVE'], 'Users', username).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
rescue
  "C:/Users/#{username}"
end

def task_query(task_name)
  shell_out("schtasks /Query /FO LIST /V /TN \"#{task_name}\"").stdout
end

def task_completed?(task_name)
  out = task_query(task_name)
  status = /^Status:(.*)$/.match(out).captures[0]
  status.strip == 'Ready'
end
