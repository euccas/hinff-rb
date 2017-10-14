##############################################################
##  Ruby Code Hinff
##  File Name:   inf_test.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################
module Hinff

  def gen_testlist_file(testfile, test_names)
    unless is_var_defined(test_names)
      display_info('no valid test names, cannot generate testlist file')
      return
    end

    tnames = test_names.gsub(/\s/,'')
    tests = tnames.split(',')
    begin
      File.open(testfile, 'w') do |f|
        tests.each do |t|
          f.write(t)
          f.write("\n")
        end
      end
    rescue Exception => e
      display_info("Cannot write to testlist file: #{testfile}")
      display_info e.message
    end

  end # gen_testlist_file

  def testnames_in_list(testlist)
    assert_missing_file(testlist)
    testnames = Array.new
    File.readlines(testlist).each do |line|
      if line.match(/^#/) || line.match(/^$/)
        # skip comments and empty lines
      else
        if line.match(/\n/)
          line.chomp!
        end
        testnames.push(line)
      end
    end
    n_test = testnames.size()
    display_info("found #{n_test} tests in list #{testlist}")

    return testnames
  end

  def testnames_in_dir(vectordir)
    assert_missing_dir(vectordir)
    testnames = Array.new
    test_vector_paths = Array.new
    test_vector_paths = Dir["#{vectordir}/*"].reject { |o| not File.directory?(o) }
    test_vector_paths.each do |t_path|
      tname = File.basename(t_path)
      testnames.push(tname)
    end
    n_test = testnames.size()
    display_info("found #{n_test} tests in vector directory #{vectordir}")

    return testnames
  end

  def get_valid_testnames(testnames, vectordir)
    valid_testnames = Array.new
    if is_dir_exist(vectordir) == false
      display_warning("vector dir #{vectordir} does not exist!")
    elsif testnames.empty?
      display_warning('no test names found!')
    else
      # array vector names store all directory names in vector dir
      vectornames = Array.new
      test_vector_paths = Array.new
      test_vector_paths = Dir["#{vectordir}/*"].reject { |o| not File.directory?(o) }
      test_vector_paths.each do |t_path|
        vname = File.basename(t_path)
        vectornames.push(vname)
      end
      # intersect vectornames and testnames to get valid testnames
      valid_testnames = testnames & vectornames
    end
    return valid_testnames
  end

end
