class AlterViewCpuGridNormRecordsB < ActiveRecord::Migration
  def up
    CpuGridNormRecord.connection.execute('DROP VIEW `cpu_grid_norm_records`')
    CpuGridNormRecord.connection.execute('
    CREATE VIEW `cpu_grid_norm_records` AS 
      select 
        `batch`.`id` AS `id`,
        `batch`.`publisher_id` AS `publisher_id`,
        `batch`.`lrmsId` AS `lrmsId`,
        `batch`.`recordDate` AS `recordDate`,
        `batch`.`localUser` AS `localUser`,
        `batch`.`execHost` AS `execHost`,
        `batch`.`resourceList_nodect` AS `nodect`,
        `batch`.`resourceList_nodes` AS `nodes`,
        `batch`.`resourceUsed_cput` AS `cput`,
        `batch`.`resourceUsed_walltime` AS `wallt`,
        `batch`.`resourceUsed_mem` AS `pmem`,
        `batch`.`resourceUsed_vmem` AS `vmem`,
        `blah`.`userDN` AS `userDN`,
        `blah`.`userFQAN` AS `FQAN`,
        `blah`.`vo` AS `vo`,
        `blah`.`voGroup` AS `voGroup`,
        `blah`.`voRole` AS `voRole`,
        `bv`.`id` AS `benchmark_value_id`
    from
        (((`cpu_grid_ids` `ids`
        left join `batch_execute_records` `batch` ON ((`ids`.`batch_execute_record_id` = `batch`.`id`)))
        left join `blah_records` `blah` ON ((`ids`.`blah_record_id` = `blah`.`id`)))
        left join `benchmark_values` `bv` ON (((`bv`.`publisher_id` = `batch`.`publisher_id`)
            and (`bv`.`date` = cast(`batch`.`recordDate` as date)))))
    ')
  end
  
  def down
    CpuGridNormRecord.connection.execute('DROP VIEW `cpu_grid_norm_records`')
    CpuGridNormRecord.connection.execute('
    CREATE VIEW `cpu_grid_norm_records` AS 
      select `batch`.`id` AS `id`,
      `batch`.`publisher_id` AS `publisher_id`,
      `batch`.`lrmsId` AS `lrmsId`,
      `batch`.`recordDate` AS `recordDate`,
      `batch`.`localUser` AS `localUser`,
      `batch`.`execHost` AS `execHost`,
      `batch`.`resourceList_nodect` AS `nodect`,
      `batch`.`resourceList_nodes` AS `nodes`,
      `batch`.`resourceUsed_cput` AS `cput`,
      `batch`.`resourceUsed_walltime` AS `wallt`,
      `batch`.`resourceUsed_mem` AS `pmem`,
      `batch`.`resourceUsed_vmem` AS `vmem`,
      `blah`.`userDN` AS `userDN`,
      `blah`.`userFQAN` AS `FQAN`,
      `blah`.`vo` AS `vo`,
      `blah`.`voGroup` AS `voGroup`,
      `blah`.`voRole` AS `voRole`,
       (select `benchmark_values`.`id` from `benchmark_values` 
          where ((`benchmark_values`.`publisher_id` = `batch`.`publisher_id`) and (`benchmark_values`.`date` < `batch`.`recordDate`)) 
            order by `batch`.`recordDate` desc limit 1) AS `benchmark_value_id` 
       from ((`cpu_grid_ids` `ids` left join `batch_execute_records` `batch` on((`ids`.`batch_execute_record_id` = `batch`.`id`))) 
                                    left join `blah_records` `blah` on((`ids`.`blah_record_id` = `blah`.`id`)));
    ')
  end
end