class CreateOfficeOpenXmls < ActiveRecord::Migration
  def self.up
    create_table :office_open_xmls do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :office_open_xmls
  end
end
