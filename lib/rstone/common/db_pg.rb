##############################################################
##  Ruby Code Rstone -- Database
##  File Name:   db_pg.rb
##  Owner:  Euccas Chen <euccas.chen@gmail.com>
##############################################################

module Rstone
  module DBPg

    require 'pg'

    def db_connect(host, port, dbname, user, password)
      begin
        conn = PGconn.connect(host, port, '', '', dbname, user, password)
      rescue
        display_info("Fail to connect to database #{dbname} on #{host}")
      end
      return conn
    end

    def is_db_exist(db_conn, db_name)
      # return: exist (boolean)
      exist = false
      assert_undefined_var(db_name, 'db_name')

      sql_query =<<-END_SQL_QUERY.gsub(/\s+/, ' ').strip
      SELECT 1 from pg_database WHERE datname='#{db_name}'
      END_SQL_QUERY
      res = db_conn.exec(sql_query)
      if res.cmd_status() == 'SELECT 1'
        exist = true
      end

      return exist
    end # is_db_exist

    def is_table_exist(db_conn, table_name)
      exist = false

      assert_undefined_var(table_name, 'table_name')

      sql_cmd =<<-END_SQL_CMD.gsub(/\s+/, ' ').strip
        SELECT EXISTS(
            SELECT *
            FROM information_schema.tables
            WHERE
              table_name = \'#{table_name}\'
        );
      END_SQL_CMD
      res = db_conn.exec(sql_cmd)
      if res.cmd_status() == 'SELECT 1'
        if res[0]['exists'].match(/^t/i)
          exist = true
        end
      end

      return exist
    end # is_table_exist

    def show_db_table_records(host, port, dbname, user, password, table)
      db_conn = db_connect(host, port, dbname, user, password)
      sql_cmd =<<-END_SQL_CMD.gsub(/\s+/, ' ').strip
      SELECT * FROM #{table}
      END_SQL_CMD
      db_conn.exec(sql_cmd) do |result|
        cols = result.fields()
        cols.each do |col|
          print col + ' | '
        end
        puts
        sep_line(60, '-')

        result.each do |row|
          cols.each do |col|
            print row.values_at(col)
          end
          puts
          sep_line(60, '-')
        end
      end
    end # show_db_table_records

  end # Module: DBPg

end # Module: Rstone
