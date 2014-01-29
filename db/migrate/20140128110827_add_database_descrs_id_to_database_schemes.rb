class AddDatabaseDescrsIdToDatabaseSchemes < ActiveRecord::Migration
  def change
    add_column :database_schemes, :database_descr_id, :integer
  end
end
