class CreateDatabaseDescrs < ActiveRecord::Migration
  def change
    create_table :database_descrs do |t|
      t.string :backend
      t.string :backendVersion
      t.integer :database_scheme_id

      t.timestamps
    end
  end
end
