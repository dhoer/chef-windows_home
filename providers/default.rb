action :create do
  if platform?('windows')
    task_name = "build_#{new_resource.username}_home"
    user_home = home_dir(new_resource.username)

    # Create whoami as scheduled task to get Local Server group privilege:
    # SeAssignPrimaryTokenPrivilege (Replace a process-level token)
    execute "create_#{task_name}_task" do
      sensitive true
      command <<-EOF
schtasks /Create /TN "#{task_name}" /SC once /SD "01/01/2003" /ST "00:00" \
/TR "whoami.exe" /RU "#{new_resource.username}" /RP "#{new_resource.password}" /RL HIGHEST
      EOF
      only_if { task_query(task_name).empty? }
    end

    execute "run_#{task_name}_task" do
      command "schtasks /Run /TN \"#{task_name}\""
      not_if { ::File.exist?(user_home) }
    end

    ruby_block "wait_until_#{task_name}_task_completed" do
      block do
        sleep(1) until task_completed?(task_name)
      end
      action :run
    end

    execute "delete_#{task_name}_task" do
      command "schtasks /Delete /TN \"#{task_name}\" /F"
      not_if { task_query(task_name).empty? }
    end

    new_resource.updated_by_last_action true
    log "#{user_home} created"
  else
    log 'Resource windows_home is only available for Windows platform!' do
      level :warn
    end
  end
end
