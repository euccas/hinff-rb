require "inflib/version"
require 'inflib/code'
require 'inflib/utils'
require 'inflib/infutils'
require 'inflib/lsf'
require 'inflib/email'
require 'inflib/db'

require 'fileutils'
require 'open3'
require 'yaml'
require 'net/smtp'
require 'pg'

if /linux/ =~ RUBY_PLATFORM
  require 'pty'
  require 'expect'
end

module Inflib
  # Your code goes here...
end
