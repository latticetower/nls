class CreateBoxingTypes < ActiveRecord::Migration
  def self.up
    create_table :boxing_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :boxing_types
  end
end
