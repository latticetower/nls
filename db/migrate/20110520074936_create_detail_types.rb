class CreateDetailTypes < ActiveRecord::Migration
  def self.up
    create_table :detail_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :detail_types
  end
end
