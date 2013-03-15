class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|
      t.string :hostname
      t.string :ip
      t.string :token

      t.timestamps
    end
  end
end
