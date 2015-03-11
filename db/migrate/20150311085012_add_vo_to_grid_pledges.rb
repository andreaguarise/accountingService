class AddVoToGridPledges < ActiveRecord::Migration
  def change
    add_column :grid_pledges, :vo, :string
  end
end
