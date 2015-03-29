require 'spec_helper'

describe 'windows_home_test::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', step_into: ['windows_home']) do
        allow_any_instance_of(Chef::Recipe).to receive(:home_dir).and_return('file')
      end.converge(described_recipe)
    end

    it 'creates user' do
      expect(chef_run).to create_user('newuser').with(
        password: 'N3wPassW0Rd'
      )
    end

    it 'adds user to administrator group' do
      expect(chef_run).to modify_group('Administrators').with(
        members: ['newuser'],
        append: true
      )
    end

    it 'creates home' do
      expect(chef_run).to create_windows_home('newuser').with(
        password: 'N3wPassW0Rd'
      )
    end

    it 'creates task' do
      expect(chef_run).to run_execute('create_build_newuser_home_task').with(
        sensitive: true,
        command: "schtasks /Create /TN \"build_newuser_home\" /SC once /SD \"01/01/2003\" /ST \"00:00\" /TR"\
          " \"whoami.exe\" /RU \"newuser\" /RP \"N3wPassW0Rd\" /RL HIGHEST\n"
      )
    end

    it 'runs task' do
      expect(chef_run).to run_execute('run_build_newuser_home_task').with(
        command: "schtasks /Run /TN \"build_newuser_home\""
      )
    end

    it 'waits for task to complete' do
      expect(chef_run).to run_ruby_block('wait_until_build_newuser_home_task_completed')
    end

    it 'deletes task' do
      allow_any_instance_of(Chef::Recipe).to receive(:task_query).and_return('Ready')
      expect(chef_run).to_not run_execute('delete_build_newuser_home_task').with(
        command: "schtasks /Delete /TN \"build_newuser_home\""
      )
    end

    it 'logs user home is created' do
      expect(chef_run).to write_log('C:/Users/newuser created')
    end
  end

  context 'non_windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04',
                               step_into: ['windows_home']).converge(described_recipe)
    end

    it 'should warn if not Windows platform' do
      expect(chef_run).to write_log('Resource windows_home is only available for Windows platform!')
    end
  end
end
