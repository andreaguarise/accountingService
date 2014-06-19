class CreateViewCpuGridSummaries < ActiveRecord::Migration
  def up
    CpuGridSummary.connection.execute('
    CREATE VIEW `cpu_grid_summaries` AS
    select 
        `cpu_grid_norm_records`.`id` AS `id`,
        cast(`cpu_grid_norm_records`.`recordDate` as date) AS `date`,
        `cpu_grid_norm_records`.`publisher_id` AS `publisher_id`,
        `cpu_grid_norm_records`.`userDN` AS `userDN`,
        `cpu_grid_norm_records`.`vo` AS `vo`,
        `cpu_grid_norm_records`.`FQAN` AS `FQAN`,
        count(`cpu_grid_norm_records`.`id`) AS `records`,
        sum(`cpu_grid_norm_records`.`cput`) AS `cput`,
        sum(`cpu_grid_norm_records`.`wallt`) AS `wallt`,
        avg(`benchmark_values`.`value`) AS `benchmark_value`,
        `benchmark_values`.`benchmark_type_id` AS `benchmark_type_id`
    from
        (`cpu_grid_norm_records`
        left join `benchmark_values` ON ((`benchmark_values`.`id` = `cpu_grid_norm_records`.`benchmark_value_id`)))
    group by cast(`cpu_grid_norm_records`.`recordDate` as date) , `cpu_grid_norm_records`.`publisher_id` , `cpu_grid_norm_records`.`userDN` , `cpu_grid_norm_records`.`vo` , `cpu_grid_norm_records`.`FQAN` , `benchmark_values`.`benchmark_type_id`
    ')
  end
  
  def down
    CpuGridSummary.connection.execute('DROP VIEW `cpu_grid_summaries`')
  end
end
