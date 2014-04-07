class CreateDatabaseRecordSummaries < ActiveRecord::Migration
  def change
    create_table :database_record_summaries do |t|
      t.date :record_date
      t.string :table_name
      t.string :scheme_name
      t.integer :rows
      t.integer :tablesize
      t.integer :indexsize
      t.integer :publisher_id
      t.integer :database_descr_id

      t.timestamps
    end
  end
end
