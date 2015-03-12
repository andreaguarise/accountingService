class AddTypeToSites < ActiveRecord::Migration
  def change
    add_column :sites, :type, :string
  end
end
