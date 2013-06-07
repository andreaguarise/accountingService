class ChangeColumnToStorageSummaryOnesA < ActiveRecord::Migration
  def up
    change_column :storage_summary_ones,:storageClass, :string
  end

  def down
  end
end
