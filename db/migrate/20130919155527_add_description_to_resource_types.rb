class AddDescriptionToResourceTypes < ActiveRecord::Migration
  def change
    add_column :resource_types, :description, :string
  end
end
