class AlterViewCpuGridNormRecordsC < ActiveRecord::Migration
  def up
    CpuGridNormRecord.connection.execute('DROP VIEW IF EXISTS `cpu_local_ids`')
    CpuGridNormRecord.connection.execute('DROP VIEW IF EXISTS `cpu_grid_summaries`')
    CpuGridNormRecord.connection.execute('DROP VIEW IF EXISTS `cpu_grid_norm_records`')
    CpuGridNormRecord.connection.execute('DROP VIEW IF EXISTS `cpu_grid_ids`')
    CpuGridNormRecord.connection.execute('
    CREATE OR REPLACE VIEW `cpu_grid_norm_records` AS 
      select 
        `apel`.`id` AS `id`,
        `apel`.`publisher_id` AS `publisher_id`,
        `apel`.`recordDate` AS `recordDate`,
        `apel`.`submitHost` AS `submitHost`,
        `apel`.`machineName` AS `machineName`,
        `apel`.`queue` AS `queue`,
        `apel`.`localJobId` AS `localJobId`,
        `apel`.`localUserId` AS `localUserId`,
        `apel`.`globalUserName` AS `globalUserName`,
        `apel`.`fqan` AS `fqan`,
        `apel`.`vo` AS `vo`,
        `apel`.`voGroup` AS `voGroup`,
        `apel`.`voRole` AS `voRole`,
        `apel`.`wallDuration` AS `wallDuration`,
        `apel`.`cpuDuration` AS `cpuDuration`,
        `apel`.`processors` AS `processors`,
        `apel`.`nodeCount` AS `nodeCount`,
        `apel`.`startTime` AS `startTime`,
        `apel`.`endTime` AS `endTime`,
        `apel`.`infrastructureDescription` AS `infrastructureDescription`,
        `apel`.`infrastructureType` AS `infrastructureType`,
        `apel`.`memoryReal` AS `memoryReal`,
        `apel`.`memoryVirtual` AS `memoryVirtual`,
        `apel`.`created_at` AS `created_at`,
        `apel`.`updated_at` AS `updated_at`,
        `bv`.`id` AS `benchmark_value_id`
    from
        (`apel_ssm_records` `apel`
        left join `benchmark_values` `bv` ON (((`bv`.`publisher_id` = `apel`.`publisher_id`)
            and (`bv`.`date` = cast(`apel`.`recordDate` as date)))))
    ')
    CpuGridNormRecord.connection.execute('
    CREATE OR REPLACE VIEW `cpu_grid_summaries` AS 
      select 
        `cpu_grid_norm_records`.`id` AS `id`,
        cast(`cpu_grid_norm_records`.`recordDate`
            as date) AS `date`,
        `cpu_grid_norm_records`.`publisher_id` AS `publisher_id`,
        `cpu_grid_norm_records`.`globalUserName` AS `globalUserName`,
        `cpu_grid_norm_records`.`vo` AS `vo`,
        `cpu_grid_norm_records`.`fqan` AS `fqan`,
        count(`cpu_grid_norm_records`.`id`) AS `records`,
        sum(`cpu_grid_norm_records`.`cpuDuration`) AS `cpuDuration`,
        sum(`cpu_grid_norm_records`.`wallDuration`) AS `wallDuration`,
        avg(`benchmark_values`.`value`) AS `benchmark_value`,
        `benchmark_values`.`benchmark_type_id` AS `benchmark_type_id`
    from
        (`cpu_grid_norm_records`
        left join `benchmark_values` ON ((`benchmark_values`.`id` = `cpu_grid_norm_records`.`benchmark_value_id`)))
    group by cast(`cpu_grid_norm_records`.`recordDate`
        as date) , `cpu_grid_norm_records`.`publisher_id` , `cpu_grid_norm_records`.`globalUserName` , `cpu_grid_norm_records`.`vo` , `cpu_grid_norm_records`.`fqan` , `benchmark_values`.`benchmark_type_id`
        ')
  end
  
  def down
  end
end
