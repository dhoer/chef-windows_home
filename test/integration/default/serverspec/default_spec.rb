require 'serverspec_helper'

describe 'windows_home_test::default' do
  if os[:family] == 'windows'
    describe file('C:/Users/newuser') do
      it { should be_directory }
    end

    describe file('C:/Users/newuser/AppData/Roaming/Microsoft/Windows/Start Menu') do
      it { should be_directory }
    end
  end
end
