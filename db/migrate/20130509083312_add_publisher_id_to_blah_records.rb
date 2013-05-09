class AddPublisherIdToBlahRecords < ActiveRecord::Migration
  def change
    add_column :blah_records, :publisher_id, :integer
  end
end
