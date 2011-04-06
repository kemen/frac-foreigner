module Foreigner
  module ConnectionAdapters
    module PostgreSQLAdapter
      include Foreigner::ConnectionAdapters::Sql2003

      def remove_foreign_key(table, options)
        if Hash === options
          foreign_key_name = foreign_key_name(table, options[:column], options)
        else
          foreign_key_name = foreign_key_name(table, "#{options.to_s.singularize}_id")
        end

        execute "ALTER TABLE #{quote_table_name(table)} DROP CONSTRAINT #{quote_column_name(foreign_key_name)}"
      end

      def add_primary_key(table,options)
        constraint_name = "pk_#{table}}"
        execute "ALTER TABLE #{table} ADD CONSTRAINT #{constraint_name} PRIMARY KEY (#{options[:column]})"
      end

      def remove_primary_key(table, options)
        constraint_name = "pk_#{table}}"
        execute "ALTER TABLE #{table} DROP CONSTRAINT #{constraint_name}"
      end      

      def pk(table_name)
        pk_info = select_all %{
          select c.COLUMN_NAME as pk
            from INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk, INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
            where pk.TABLE_NAME = '#{table_name}'
            and	CONSTRAINT_TYPE = 'PRIMARY KEY'
            and	c.TABLE_NAME = pk.TABLE_NAME
            and	c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
        }
        pk_info.map do |row|
          options = {:pk => row['pk']}
          options
        end
      end

      def foreign_keys(table_name)
        fk_info = select_all %{
          SELECT tc.constraint_name as name
                ,ccu.table_name as to_table
                ,ccu.column_name as primary_key
                ,kcu.column_name as column
                ,rc.delete_rule as dependency
          FROM information_schema.table_constraints tc
          JOIN information_schema.key_column_usage kcu
          USING (constraint_catalog, constraint_schema, constraint_name)
          JOIN information_schema.referential_constraints rc
          USING (constraint_catalog, constraint_schema, constraint_name)
          JOIN information_schema.constraint_column_usage ccu
          USING (constraint_catalog, constraint_schema, constraint_name)
          WHERE tc.constraint_type = 'FOREIGN KEY'
            AND tc.constraint_catalog = '#{@config[:database]}'
            AND tc.table_name = '#{table_name}'
        }
        
        fk_info.map do |row|
          options = {:column => row['column'], :name => row['name'], :primary_key => row['primary_key']}

          options[:dependent] = case row['dependency']
            when 'CASCADE'  then :delete
            when 'SET NULL' then :nullify
            when 'RESTRICT' then :restrict
          end

          ForeignKeyDefinition.new(table_name, row['to_table'], options)
        end
      end
    end
  end
end

[:PostgreSQLAdapter, :JdbcAdapter].each do |adapter|
  begin
    ActiveRecord::ConnectionAdapters.const_get(adapter).class_eval do
      include Foreigner::ConnectionAdapters::PostgreSQLAdapter
    end
  rescue
  end
end
