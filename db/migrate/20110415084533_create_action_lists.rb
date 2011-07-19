class CreateActionLists < ActiveRecord::Migration
  def self.up
    create_table :action_lists do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :action_lists
  end
end
