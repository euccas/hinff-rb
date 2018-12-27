##############################################################
##  Ruby Code Rstone -- LSF
##  File Name:   lsf.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################
module Rstone
  def bsub_code(code, queue, outdir)
    ### output: [file] bsub_record

    assert_missing_file(code)
    if is_var_defined(outdir) == false
      outdir = Dir.pwd
    end
    assert_missing_dir(outdir)

    code_name = File.basename(code)
    bsub_record = outdir + "/bsub_record_#{code_name}.txt"
    bjob_log_o = outdir + "/bjob_#{code_name}.log"
    bjob_log_e = outdir + "/bjob_#{code_name}.log2"
    cmd_bsub = "bsub -o #{bjob_log_o} -e #{bjob_log_e} -R 'sles11 && select[mem>1000] rusage[mem=1000]' "
    cmd = cmd_bsub + code
    puts cmd
    o, e, s = Open3.capture3(cmd)
    unless is_var_defined(o)
      assert_error('error', "bsub failed when submiting #{code}")
    end
    begin
      File.open(bsub_record, 'w') do |f|
        f.write(o)
        f.write("\n")
        f.write("output log: #{bjob_log_o} \n")
        f.write("error log: #{bjob_log_e} \n")
      end
    rescue IOError => e
      puts e.message
    end

    assert_missing_file(bsub_record)

    return bsub_record
  end # bsub_code

  def bsub_cmd(cmd, queue)
  end # bsub_cmd

  def get_bjob_id_from_record(bsub_record)
    ### output: [string] bjob id
    assert_missing_file(bsub_record)

    bjob_id = ''
    File.readlines(bsub_record).each do |line|
      if line.match(/Job <(\d+)> is submitted/)
        bjob_id = $1
      end
    end

    if bjob_id == ''
      assert_error('error', "couldn't get bjob id from record file #{bsub_record}")
    end

    return bjob_id
  end # get_bjob_id_from_record

  def get_bjob_logs_from_record(bsub_record)
    ### output: [array of string] bjob output log and error log
    assert_missing_file(bsub_record)

    bjob_logs = Array.new
    File.readlines(bsub_record).each do |line|
      if line.match(/log: (.*)/)
        bjob_logs.push($1)
      end
    end

    if bjob_logs.size == 0
      display_warning("couldn't find bjob logs from record file #{bsub_record}")
    end

    return bjob_logs
  end # get_bjob_logs_from_record

  def get_bjob_output_log_from_record(bsub_record)
    ### output: bjob output log
    assert_missing_file(bsub_record)

    bjob_log = ''
    File.readlines(bsub_record).each do |line|
      if line.match(/output log: (.*)/)
        bjob_log = $1
        break
      end
    end

    if bjob_log == ''
      display_warning("couldn't find bjob output log from record file #{bsub_record}")
    end

    return bjob_log
  end # get_bjob_output_log_from_record

  def get_bjob_error_log_from_record(bsub_record)
    ### output: bjob output log
    assert_missing_file(bsub_record)

    bjob_log = ''
    File.readlines(bsub_record).each do |line|
      if line.match(/error log: (.*)/)
        bjob_log = $1
        break
      end
    end

    if bjob_log == ''
      display_warning("couldn't find bjob error log from record file #{bsub_record}")
    end

    return bjob_log
  end # get_bjob_error_log_from_record

  def bjob_mon_by_id(job_ids)
  end # bjob_mon_by_id

  def bjob_batch_mon_by_record(bsub_record_file)
    ### This function reads a bsub record file which could contain multiple submission ids
    ### output: an array of finished bjob ids
    assert_missing_file(bsub_record_file)

    finish_job_ids = Array.new
    mon_job_ids = Array.new
    File.readlines(bsub_record_file).each do |line|
      if line.match(/Job \<(\d+)\> is submitted to queue/)
        mon_job_ids.push($1)
      end
    end

    if mon_job_ids.length == 0
      display_warning("no valid LSF job id is found in the bsub record file: #{bsub_record_file}")
      display_warning('bsub job monitor exits')
    else
      mon_job_ids.each do |id|
        cmd = "bjobs #{id}"
        o, e, s = Open3.capture3(cmd)
        if (o == '' and e.match(/not found/)) or (o.match(/DONE/) or (o.match(/EXIT/)) and e == '')
          finish_job_ids.push(id)
          display_info("found finished bsub job: #{id}")
        end
      end
    end

    return finish_job_ids
  end # bjob_batch_mon_by_record

  def bjob_batch_mon_by_ids(job_ids)
    ### This function monitors multiple LSF job ids and return an array of the finished ids
    ### input: an array of LSF job ids
    ### output: [array of string] finished bjob id
    finish_job_ids = Array.new
    mon_job_ids = Array.new
    mon_job_ids = job_ids

    if mon_job_ids.length == 0
      assert_error('error', "#{__method__}: invalid bsub job ids")
    end
    mon_job_ids.each do |id|
      cmd = "bjobs #{id}"
      o, e, s = Open3.capture3(cmd)
      if (o == '' and e.match(/not found/)) or (o.match(/DONE/) or (o.match(/EXIT/)) and e == '')
        finish_job_ids.push(id)
        display_info("found finished bsub job: #{id}")
      end
    end

    return finish_job_ids
  end # bjob_batch_mon_by_ids

  def lsf_jobs_batch_monitor(job_ids, querytime_min, killtime_min)
    ### This methods use bjob_batch_mon_by_ids

    display_info('Start LSF Job Batch Monitor ...')

    job_no = job_ids.size
    job_ids_str = job_ids.join("\t")
    display_info("* Total number of LSF jobs:\t#{job_no}")
    display_info("* LSF job IDs:\t#{job_ids_str}")

    if job_no == 0
      display_warning('no valid LSF job id is found')
      display_warning('LSF job batch monitor exits')
    else
      if querytime_min < 1
        display_warning('lsf querytime cannot be less than 1 minute')
        querytime = 1
        display_info("set lsf querytime to default value: #{querytime_min} minute")
      end
      query_interval_seconds = querytime_min * 60

      if killtime_min < 3
        display_warning('lsf killtime cannot be less than 3 minutes')
        killtime_min = 3
        display_info("set lsf killtime to default value: #{killtime_min} minutes")
      end

      starttime = get_time_now('short')
      current_runtime = 0
      current_loop = 0
      all_finished_bjobs = Array.new
      while current_runtime < killtime_min and all_finished_bjobs.length < job_no do
        current_loop += 1
        display_info("query lsf jobs status - loop #{current_loop} - start time: #{starttime} - elapsed time: #{current_runtime} minutes ...")

        current_bjob_finish = Array.new
        current_bjob_finish = bjob_batch_mon_by_ids(job_ids)
        if current_bjob_finish.length > 0
          new_bjob_finish = Array.new
          current_bjob_finish.each do |id|
            if not all_finished_bjobs.include?(id)
              new_bjob_finish.push(id)
              all_finished_bjobs.push(id)
            end
          end
          cnt_new_finish = new_bjob_finish.length
          display_info("found #{cnt_new_finish} newly finished lsf jobs")
          if new_bjob_finish.length > 0
            new_finish_job_id = new_bjob_finish.join("\t")
            display_info("lsf job id: #{new_finish_job_id}")
          end
        else
          display_info('no newly finished lsf jobs found in this query')
          if querytime_min > 1
            display_info("waiting for the next query, scheduled in #{querytime_min} minutes ...")
          else
            display_info("waiting for the next query, scheduled in #{querytime_min} minute ...")
          end
        end
        sleep(query_interval_seconds)
        current_runtime += querytime_min
      end # of while loop

      cnt_finish = all_finished_bjobs.length
      cnt_unfinish = job_no - cnt_finish
      display_info("Total LSF jobs:\t#{job_no}")
      display_info("Finished LSF jobs:\t#{cnt_finish}")
      if cnt_finish == job_no
        display_info('All LSF jobs have been finished!')
      else
        cnt_finish = all_finished_bjobs.length
        cnt_unfinish = job_no - cnt_finish
        display_info("Unfinished LSF jobs:\t#{cnt_unfinish}")
        display_warning("There are #{cnt_unfinish} LSF jobs are terminated as runtime exceeded LSF killtime")
        display_info("LSF killtime:\t#{killtime_min} minutes")
      end
    end # if job_no == 0
  end # def lsf_jobs_batch_monitor

end
