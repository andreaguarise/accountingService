class CreateDatabaseTables < ActiveRecord::Migration
  def change
    create_table :database_tables do |t|
      t.string :name
      t.integer :database_scheme_id

      t.timestamps
    end
  end
end
