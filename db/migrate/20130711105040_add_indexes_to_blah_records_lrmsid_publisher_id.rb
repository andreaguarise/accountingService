class AddIndexesToBlahRecordsLrmsidPublisherId < ActiveRecord::Migration
  def change
    add_index :blah_records, :lrmsId
    add_index :blah_records, :publisher_id
  end
end
