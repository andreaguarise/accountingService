class ChangeColumnToApelSsmRecords < ActiveRecord::Migration
  def up
    change_column :apel_ssm_records,:queue, :string
    change_column :apel_ssm_records,:voGroup, :string
    change_column :apel_ssm_records,:voRole, :string
    add_index :apel_ssm_records, :publisher_id
    add_index :apel_ssm_records, :recordDate
    add_index :apel_ssm_records, :vo
  end

  def down
  end
end
