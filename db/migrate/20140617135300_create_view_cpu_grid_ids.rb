class CreateViewCpuGridIds < ActiveRecord::Migration
  def up
    CpuGridId.connection.execute('CREATE VIEW `cpu_grid_ids` AS
    select 
        `batch`.`id` AS `id`,
        `batch`.`id` AS `batch_execute_record_id`,
        `blah`.`id` AS `blah_record_id`
    from
        (((`batch_execute_records` `batch`
        join `blah_records` `blah` ON (((`batch`.`lrmsId` = `blah`.`lrmsId`)
            and (`batch`.`recordDate` >= `blah`.`recordDate`))))
        join `publishers` `batch_p` ON ((`batch_p`.`id` = `batch`.`publisher_id`)))
        join `publishers` `blah_p` ON ((`blah_p`.`id` = `blah`.`publisher_id`)))
    where
        ((`batch_p`.`resource_id` = `blah_p`.`resource_id`)
            and (`blah`.`id` is not null))
    ')
  end

  def down
    CpuGridId.connection.execute('DROP VIEW `cpu_grid_ids`')
  end
end
