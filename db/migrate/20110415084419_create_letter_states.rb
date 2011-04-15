class CreateLetterStates < ActiveRecord::Migration
  def self.up
    create_table :letter_states do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :letter_states
  end
end
