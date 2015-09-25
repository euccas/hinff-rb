##############################################################
##  Ruby Code Infra Lib -- Coding Helper
##  File Name:   code.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################

module Inflib
  
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
    #puts "ENV['#{env}'] is set to: #{value}"
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
      #puts "File #{file} doesn't exist. Skip rm action."
    end
  end

  def rm_exist_dir(dir)
    if File.directory?(dir)
      FileUtils.rm_rf(dir)
    else
      #puts "Directory #{dir} doesn't exist. Skip rm action."
    end
  end

  def display_ok()
    if $logger
      $logger.info '... ok'
    else
      puts '... ok'
    end
  end

  def display_info(msg)
    if msg.match("\n$")
      msg.chomp!
    end
    if $logger
      $logger.info "#{msg}"
    else
      puts "[INFO] #{msg}"
    end
  end

  def display_warning(msg)
    if msg.match("\n$")
      msg.chomp!
    end
    if $logger
      $logger.warn "#{msg}"
    else
      puts "[WARNING] #{msg}"
    end
  end

  def is_file_exist(file)
    isexist = false
    file = file.dup
    if File.exist?(file)
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
      display_info("directory #{dir} already exists, skip creating dir")
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
    unless is_file_exist(file) == true
      if $logger
        $logger.error "Missing file: #{file}"
      else
        puts "[ERROR] Missing file: #{file}"
      end
      app_exit(1, '')
    end
  end

  def assert_missing_dir(dir)
    dir = dir.dup
    unless is_dir_exist(dir) == true
      if $logger
        $logger.error "[ERROR] Missing directory: #{dir}"
      else
        puts "[ERROR] Missing directory: #{dir}"
      end
      app_exit(1, '')
    end
  end

  def assert_missing_opt(var, opt, msg)
    if var == nil or var == ''
      if $logger
        $logger.error "[ERROR] Require option #{opt}: #{msg}"
      else
        puts "[ERROR] Require option #{opt}: #{msg}"
      end
      app_exit(1, '')
    end
  end

  def assert_error(category, error_msg)
    if category == 'error'
      category = ''
    else
      category += ':'
    end
    if $logger
      $logger.error "#{category} #{error_msg}"
    else
      puts "[ERROR] #{category} #{error_msg}"
    end
    app_exit(1, '')
  end

  def app_exit(exit_code, exit_msg)
    if $logger
      $logger.info "EXIT #{exit_code}: #{exit_msg}"
    else
      puts "EXIT #{exit_code}: #{exit_msg}"
    end
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
      if $logger
        $logger.error "Unexist variable: #{varname}"
      else
        puts "[ERROR] Unexist variable: #{varname}"
      end
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
      if $logger
        $logger.error "[ERROR] Undefined variable: #{varname}"
      else
        puts "[ERROR] Undefined variable: #{varname}"
      end
      app_exit(1, '')
    end
  end

  def data_validate(var, valid_values)
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


end # Module: InfLib
