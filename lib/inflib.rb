require "inflib/version"

require 'inflib/common/utils'
require 'inflib/common/lsf'
require 'inflib/common/email'
require 'inflib/common/db_pg'
require 'inflib/common/perforce'

require 'inflib/inf_test'

require 'fileutils'
require 'open3'
require 'yaml'


if /linux/ =~ RUBY_PLATFORM
  require 'pty'
  require 'expect'
end

module Inflib
  # Your code goes here...
end
