class CreateHistoryLogs < ActiveRecord::Migration
  def self.up
    create_table :history_logs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :history_logs
  end
end
