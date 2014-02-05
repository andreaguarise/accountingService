class ChangeColumnToDatabaseRecords < ActiveRecord::Migration
  def up
    change_column :database_records,:tablesize, :integer, :limit => 8
    change_column :database_records,:indexsize, :integer, :limit => 8
    change_column :database_records,:rows, :integer, :limit => 8
  end

  def down
  end
end
