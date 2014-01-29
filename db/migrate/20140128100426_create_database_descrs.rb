class CreateDatabaseDescrs < ActiveRecord::Migration
  
  def change
    create_table :database_descrs do |t|
      t.string :backend
      t.string :version

      t.timestamps
    end
  end
end
