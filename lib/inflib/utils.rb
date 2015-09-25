##############################################################
##  Ruby Code Infra Lib -- Utils
##  File Name:   utils.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################
module Inflib

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

end # Module: InfLib
