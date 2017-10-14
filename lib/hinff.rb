require "hinff/version"

require 'hinff/common/utils'
require 'hinff/common/lsf'
require 'hinff/common/email'
require 'hinff/common/db_pg'
require 'hinff/common/perforce'

require 'hinff/usecase/inf_test'

require 'fileutils'
require 'open3'
require 'yaml'


if /linux/ =~ RUBY_PLATFORM
  require 'pty'
  require 'expect'
end

module Hinff
  # Your code goes here...
end
