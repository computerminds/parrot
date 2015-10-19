dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'net/ssh'
require 'pathname'
require 'rspec'
require 'serverspec'
include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS
