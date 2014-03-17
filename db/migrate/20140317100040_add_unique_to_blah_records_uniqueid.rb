class AddUniqueToBlahRecordsUniqueid < ActiveRecord::Migration
  def change
    remove_index :blah_records, :uniqueId
    add_index :blah_records, :uniqueId, :unique => true
  end
end
