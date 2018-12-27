##############################################################
##  Ruby Code Rstone -- Utils
##  File Name:   utils.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################
module Rstone

  def show_banner(app_info, app_author)
    sep_line(86, '*')
    puts
    puts "\t#{app_info}"
    puts "\t\tCopyright (c) #{app_author}"
    banner_time = get_time_now('short')
    puts
    puts "\t\t\t#{banner_time}"
    puts
    sep_line(86, '*')
  end

  def add_env(env, value)
    if ENV[env] == nil
      #puts "ENV['#{env}'] does not exist yet"
      set_env(env, value)
    else
      ENV[env] = value + ':' + ENV[env]
      #puts "ENV['#{env}'] is updated: added #{value}"
    end
  end

  def set_env(env, value)
    ENV[env] = value
    puts "ENV['#{env}'] is set to: #{value}"
  end

  def sep_line(length, char)
    length.times do
      print "#{char}"
    end
    puts
  end

  def sep_line_blank()
    sep_line(1, ' ')
  end

  def rm_exist_file(file)
    if File.exist?(file)
      FileUtils.rm_f(file)
    else
      puts "File #{file} doesn't exist. Skip rm action."
    end
  end

  def rm_exist_dir(dir)
    if File.directory?(dir)
      FileUtils.rm_rf(dir)
    else
      puts "Directory #{dir} doesn't exist. Skip rm action."
    end
  end

  def display_ok()
    puts '... ok'
  end

  def display_info(msg)
    if msg.match("\n$")
      msg.chomp!
    end

    puts "[INFO] #{msg}"
  end

  def display_warning(msg)
    if msg.match("\n$")
      msg.chomp!
    end

    puts "[WARNING] #{msg}"
  end

  def is_file_exist(file)
    isexist = false
    file = file.dup
    if File.file?(file)
      isexist = true
    end
    return isexist
  end

  def is_dir_exist(dir)
    isexist = false
    dir= dir.dup
    if File.directory?(dir)
      isexist = true
    end
    return isexist
  end

  def mkdir_if_unexist(dir)
    if is_dir_exist(dir) == true
      display_info("directory #{dir} exists, skip creating dir")
    else
      begin
        FileUtils.mkdir_p(dir, :mode=>0777)
        display_info("created directory #{dir}")
      rescue IOError=>e
        display_info("exception occurs when creating dir #{dir}")
        puts e.message
      end
    end
  end

  def is_dir_empty(dir)
    isempty = false
    dir= dir.dup
    if Dir.entries(dir).size <= 2
      isempty = true
    end
    return isempty
  end

  def assert_missing_file(file)
    file = file.dup
    unless is_file_exist?(file) == true
      puts "[ERROR] Missing file: #{file}"
      app_exit(1, '')
    end
  end

  def assert_missing_dir(dir)
    dir = dir.dup
    unless is_dir_exist(dir) == true
      puts "[ERROR] Missing directory: #{dir}"
      app_exit(1, '')
    end
  end

  def assert_missing_opt(var, opt, msg)
    if var == nil or var == ''
      puts "[ERROR] Require option #{opt}: #{msg}"
      app_exit(1, '')
    end
  end

  def assert_error(category, error_msg)
    if category == 'error'
      category = ''
    else
      category += ':'
    end
    puts "[ERROR] #{category} #{error_msg}"
    app_exit(1, '')
  end

  def app_exit(exit_code, exit_msg)
    puts "EXIT #{exit_code}: #{exit_msg}"
    exit exit_code
  end

  def is_var_exist(var)
    isexist = true
    if var == nil
      isexist = false
    end
    return isexist
  end

  def assert_unexist_var(var, varname)
    if is_var_exist(var) == false
      puts "[ERROR] Unexist variable: #{varname}"
      app_exit(1, '')
    end
  end

  def is_var_defined(var)
    isdefined = true
    if var == nil or var == ''
      isdefined = false
    end
    return isdefined
  end

  def assert_undefined_var(var, varname)
    if is_var_defined(var) == false
      puts "[ERROR] Undefined variable: #{varname}"
      app_exit(1, '')
    end
  end

  def validate_data(var, valid_values)
    isvalid = false
    valid_values.each do |v|
      if v == var
        isvalid = true
        break
      end
    end

    valid_values_str = valid_values.join(',')
    if isvalid == false
      assert_error('error', "data validation failed (valid values: #{valid_values_str})")
    end
    return isvalid
  end

  def validate_option(option, var, valid_values)
    ## valid_values: array
    isvalid = false
    valid_values.each do |v|
      if v == var
        isvalid = true
        break
      end
    end

    valid_values_str = valid_values.join(', ')
    if isvalid == false
      assert_error('error', "Invalid value for option #{option}: #{var} (valid values: #{valid_values_str})")
    end
    return isvalid
  end

  def is_tool_exist(tool)
    isexist = false
    cmd = "which #{tool}"
    o, e, s = Open3.capture3(cmd)
    if is_var_defined(o)
      isexist = true
    end
    return isexist
  end

  def whereis_tool(tool)
    tool_path = ''

    cmd = "which #{tool}"
    o, e, s = Open3.capture3(cmd)
    if is_var_defined(o)
      tool_path = o.chomp
      display_info("Found tool #{tool}: #{tool_path}")
    else
      display_info("Couldn't find tool #{tool}")
    end

    return tool_path
  end

  def assert_missing_tool(tool)
    if is_tool_exist(tool) == false
      if $logger
        $logger.error "[ERROR] Missing tool #{tool}"
      else
        puts "[ERROR] Missing tool #{tool}"
      end
      app_exit(1, '')
    end
  end

  def get_filepath_delimiter(os)
    delim = ''
    if os == 'windows'
      delim = '\\'
    else
      delim = '/'
    end

    return delim
  end # get_filepath_delimiter

  def get_time_now(format)
    nowtime = ''
    time = Time.new
    case format
    when 'short' # 2014-06-23 12:33:10
      nowtime = time.strftime('%Y-%m-%d %H:%M:%S')
    when 'long' # Fri Jul 11 11:20:24 2014
      nowtime = time.ctime.to_s
    when 'stamp' # 1405102824
      nowtime = time.to_i
    when 'stamp_i' # 1405102824
      nowtime = time.to_i
    when 'stamp_s' # 1405102824
      nowtime = time.to_i.to_s
    when 'stamp_h' # 2014_07_11_1405102824
      nowtime = time.strftime('%Y_%m_%d') + '_' + time.to_i.to_s
    when 'stamp_hs' # 20140711_1405102824
      nowtime = time.strftime('%Y%m%d') + '_' + time.to_i.to_s
    when 'stamp_hss' # 201407111405102824
      nowtime = time.strftime('%Y%m%d') + time.to_i.to_s
    else # 2014-07-11 11:20:24 -0700
      nowtime = time.to_s
    end
    return nowtime
  end

  def get_time_now_offset(sec, format)
    newtime = ''
    time = Time.new + sec
    case format
      when 'short' # 2014-06-23 12:33:10
        newtime = time.strftime('%Y-%m-%d %H:%M:%S')
      when 'long' # Fri Jul 11 11:20:24 2014
        newtime = time.ctime.to_s
      when 'stamp' # 1405102824
        newtime = time.to_i
      when 'stamp_i' # 1405102824
        newtime = time.to_i
      when 'stamp_s' # 1405102824
        newtime = time.to_i.to_s
      when 'stamp_h' # 2014_07_11_1405102824
        newtime = time.strftime('%Y_%m_%d') + '_' + time.to_i.to_s
      when 'stamp_hs' # 20140711_1405102824
        newtime = time.strftime('%Y%m%d') + '_' + time.to_i.to_s
      when 'stamp_hss' # 201407111405102824
        newtime = time.strftime('%Y%m%d') + time.to_i.to_s
      else # 2014-07-11 11:20:24 -0700
        newtime = time.to_s
    end
    return newtime
  end # get_time_now_offset

  def get_rand_num_s(max)
    ra_s = ''
    ra_s = Random.rand(max).to_s
    return ra_s
  end

  def run_cmd_interactive_password(cmd, password, prompt)
    output = ''
    begin
      r, w, pid = PTY.spawn(cmd)
      puts r.expect(prompt)
      sleep(0.5)
      w.puts(password)
      begin
        r.each do |l|
          output += l
        end
      rescue Errno::EIO
      end
      Process.wait(pid)
    rescue PTY::ChildExited => e
      $stderr.puts "The child process #{e} exited! #{$!.status.exitstatus}"
    end
    return output
  end

  def get_os()
    os = ''

    if RUBY_PLATFORM.match(/linux/)
      os = 'linux'
    elsif RUBY_PLATFORM.match(/mingw/)
      os = 'windows'
    else
      os = 'unknown'
    end

    return os
  end

end # Module: Rstone
