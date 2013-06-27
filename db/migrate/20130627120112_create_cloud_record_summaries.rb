class CreateCloudRecordSummaries < ActiveRecord::Migration
  def change
    create_table :cloud_record_summaries do |t|
      t.date :date
      t.integer :site_id
      t.string :local_group
      t.string :local_user
      t.integer :vmCount
      t.integer :wallDuration
      t.integer :networkInBound
      t.integer :networkOutBound
      t.integer :cpuCount
      t.integer :memory

      t.timestamps
    end
  end
end
