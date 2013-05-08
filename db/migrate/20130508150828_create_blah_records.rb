class CreateBlahRecords < ActiveRecord::Migration
  def change
    create_table :blah_records do |t|
      t.string :uniqueId
      t.datetime :recordDate
      t.datetime :timestamp
      t.string :userDN
      t.string :userFQAN
      t.string :ceId
      t.string :jobId
      t.string :lrmsId
      t.integer :localUser
      t.string :clientId

      t.timestamps
    end
  end
end
