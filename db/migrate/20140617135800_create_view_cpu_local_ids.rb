class CreateViewCpuLocalIds < ActiveRecord::Migration
  def up
    CpuGridId.connection.execute('CREATE VIEW `cpu_local_ids` AS
    select 
        `batch_execute_records`.`id` AS `id`,
        `batch_execute_records`.`id` AS `batch_execute_record_id`
    from
        `batch_execute_records`
    where
        `batch_execute_records`.`lrmsId` in (select 
                `batch_execute_records`.`lrmsId`
            from
                `batch_execute_records`
            where
                (not (`batch_execute_records`.`id` in (select 
                        `cpu_grid_ids`.`id`
                    from
                        `cpu_grid_ids`))))
    ')
  end

  def down
    CpuGridId.connection.execute('DROP VIEW `cpu_local_ids`')
  end
end
