class ChangeViewGridCpuRecord < ActiveRecord::Migration
  def up
    GridCpuRecord.connection.execute('DROP VIEW grid_cpu_records')
    GridCpuRecord.connection.execute('
    CREATE VIEW `grid_cpu_records` AS SELECT `blah`.`id` as `id`, `batch`.`id` AS `batch_execute_record_id`,`blah`.`id` AS `blah_record_id` from (((`blah_records` `blah` join `batch_execute_records` `batch` on(((`blah`.`lrmsId` = `batch`.`lrmsId`) and (`batch`.`recordDate` >= `blah`.`recordDate`)))) join `publishers` `blah_p` on((`blah_p`.`id` = `blah`.`publisher_id`))) join `publishers` `batch_p` on(((`batch_p`.`id` = `batch`.`publisher_id`) and (`batch_p`.`resource_id` = `blah_p`.`resource_id`))))
    ')
  end

  def down
  end
end
