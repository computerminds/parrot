require_relative 'spec_helper'

describe user('vagrant') do
    it { should have_login_shell '/usr/bin/zsh' }
end

describe file('/home/vagrant/.zshrc') do
  it { should be_file }
  it { should be_owned_by 'vagrant' }
  it { should be_mode 644 }
  it { should contain 'Path to your oh-my-zsh installation' }
end

describe file('/home/vagrant/.oh-my-zsh') do
  it { should be_directory }
  it { should be_owned_by 'vagrant' }
  it { should be_mode 755 }
end

describe user('one', 'two') do
    it { should have_login_shell '/usr/bin/zsh' }
end
