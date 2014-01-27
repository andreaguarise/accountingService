class CreateDatabaseSchemes < ActiveRecord::Migration
  def change
    create_table :database_schemes do |t|
      t.string :name
      t.integer :publisher_id

      t.timestamps
    end
  end
end
