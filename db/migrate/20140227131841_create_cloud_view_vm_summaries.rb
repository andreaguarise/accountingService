class CreateCloudViewVmSummaries < ActiveRecord::Migration
  def up
    CloudViewVmSummary.connection.execute('
      CREATE VIEW `cloud_view_vm_summaries` AS
       select 
        `cloud_records`.`id` AS `id`,
        cast(`cloud_records`.`endTime` as date) AS `date`,
        `cloud_records`.`VMUUID` AS `VMUUID`,
        `cloud_records`.`localVMID` AS `localVMID`,
        `cloud_records`.`publisher_id` AS `publisher_id`,
        `cloud_records`.`local_user` AS `local_user`,
        `cloud_records`.`local_group` AS `local_group`,
        `cloud_records`.`status` AS `status`,
        `cloud_records`.`diskImage` AS `diskImage`,
        `cloud_records`.`cloudType` AS `cloudType`,
        avg(`cloud_records`.`disk`) AS `disk`,
        avg(`cloud_records`.`wallDuration`) AS `wallDuration`,
        avg(`cloud_records`.`cpuDuration`) AS `cpuDuration`,
        avg(`cloud_records`.`networkInbound`) AS `networkInbound`,
        avg(`cloud_records`.`networkOutBound`) AS `networkOutbound`,
        avg(`cloud_records`.`memory`) AS `memory`,
        avg(`cloud_records`.`cpuCount`) AS `cpuCount`
       from
        `cloud_records` 
       group by cast(`cloud_records`.`endTime` as date) , `cloud_records`.`VMUUID` , `cloud_records`.`status`
    ')
  end
  def down
    
  end
end
