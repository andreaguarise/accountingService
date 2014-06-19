class AddVoFieldsToBlahRecords < ActiveRecord::Migration
  def change
    add_column :blah_records, :vo, :string
    add_column :blah_records, :voGroup, :string
    add_column :blah_records, :voRole, :string
  end
end
