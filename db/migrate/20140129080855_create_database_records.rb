class CreateDatabaseRecords < ActiveRecord::Migration
  def change
    create_table :database_records do |t|
      t.datetime :time
      t.integer :rows
      t.integer :tablesize
      t.integer :indexsize
      t.integer :database_table_id

      t.timestamps
    end
  end
end
