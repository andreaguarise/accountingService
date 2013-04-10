class AddResourceIdToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :resource_id, :integer
  end
end
