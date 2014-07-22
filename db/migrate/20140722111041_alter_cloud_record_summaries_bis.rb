class AlterCloudRecordSummariesBis < ActiveRecord::Migration
  def up
    
    CloudRecordSummary.connection.execute('
      CREATE OR REPLACE 
VIEW `cloud_record_summaries` AS
    select 
        `cloud_view_vm_summaries`.`id` AS `id`,
        date_format(`cloud_view_vm_summaries`.`date`,
                "%Y-%m-%d %H:%i:00") AS `date`,
        `resources`.`site_id` AS `site_id`,
        `cloud_view_vm_summaries`.`local_group` AS `local_group`,
        `cloud_view_vm_summaries`.`local_user` AS `local_user`,
        `cloud_view_vm_summaries`.`status` AS `status`,
        count(`cloud_view_vm_summaries`.`id`) AS `vmCount`,
        sum(`cloud_view_vm_summaries`.`wallDuration`) AS `wallDuration`,
        sum(`cloud_view_vm_summaries`.`cpuDuration`) AS `cpuDuration`,
        sum(`cloud_view_vm_summaries`.`networkInbound`) AS `networkInbound`,
        sum(`cloud_view_vm_summaries`.`networkOutbound`) AS `networkOutbound`,
        sum(`cloud_view_vm_summaries`.`cpuCount`) AS `cpuCount`,
        sum(`cloud_view_vm_summaries`.`memory`) AS `memory`
    from
        ((`cloud_view_vm_summaries`
        left join `publishers` ON ((`cloud_view_vm_summaries`.`publisher_id` = `publishers`.`id`)))
        left join `resources` ON ((`publishers`.`resource_id` = `resources`.`id`)))
    group by date_format(`cloud_view_vm_summaries`.`date`,
            "%Y-%m-%d %H:%i:00") , `resources`.`site_id` , `cloud_view_vm_summaries`.`status` , `cloud_view_vm_summaries`.`local_group` , `cloud_view_vm_summaries`.`local_user`')
  end
  def down
    
  end
end
