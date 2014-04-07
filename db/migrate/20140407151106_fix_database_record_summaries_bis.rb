class FixDatabaseRecordSummariesBis < ActiveRecord::Migration
  def up
    GridCpuRecord.connection.execute('DROP VIEW database_record_summaries')
    GridCpuRecord.connection.execute('
      CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`dgas-services.to.infn.it` 
    SQL SECURITY DEFINER
VIEW `database_record_summaries` AS
    select 
        `database_records`.`id` AS `id`,
        cast(`database_records`.`time` as date) AS `record_date`,
        `database_tables`.`name` AS `table_name`,
        `database_schemes`.`name` AS `scheme_name`,
        avg(`database_records`.`rows`) AS `rows`,
        avg(`database_records`.`tablesize`) AS `tablesize`,
        avg(`database_records`.`indexsize`) AS `indexsize`,
        `database_schemes`.`publisher_id` AS `publisher_id`,
        `database_schemes`.`database_descr_id` AS `database_descr_id`
    from
        ((`database_records`
        left join `database_tables` ON ((`database_records`.`database_table_id` = `database_tables`.`id`)))
        left join `database_schemes` ON ((`database_tables`.`database_scheme_id` = `database_schemes`.`id`)))
    group by `database_schemes`.`id` , `database_tables`.`id` , cast(`database_records`.`time` as date)
    ')
  end
  def down
    
  end
end
