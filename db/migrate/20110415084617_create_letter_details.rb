class CreateLetterDetails < ActiveRecord::Migration
  def self.up
    create_table :letter_details do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :letter_details
  end
end
