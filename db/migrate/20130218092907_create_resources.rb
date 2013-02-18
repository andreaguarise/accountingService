class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.text :description
      t.integer :site_id
      t.integer :resource_type_id

      t.timestamps
    end
  end
end
