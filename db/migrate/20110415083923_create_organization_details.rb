class CreateOrganizationDetails < ActiveRecord::Migration
  def self.up
    create_table :organization_details do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :organization_details
  end
end
