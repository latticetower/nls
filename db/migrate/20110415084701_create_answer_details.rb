class CreateAnswerDetails < ActiveRecord::Migration
  def self.up
    create_table :answer_details do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_details
  end
end
