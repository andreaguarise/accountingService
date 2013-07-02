class AddIndexToBlahRecordsUniqueid < ActiveRecord::Migration
  def change
    add_index :blah_records, :uniqueId
  end
end
