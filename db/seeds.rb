# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

role = Role.create(:id => 1, :name => Russian.t('admin'), :typename => 'admin')
role = Role.create(:id => 1, :name => Russian.t('admin'), :typename => 'admin')
user = User.create(:login => 'admin', :password => 'admin', :role => role, :organization => Organization.new(:name => "CIN"), :last_sync => Time.now)
user.permissions.push(Permission.new(:name => 'create_ticket'))
user.permissions.push(Permission.new(:name => 'undo_ticket'))
user.permissions.push(Permission.new(:name => 'view_ticket'))
user.permissions.push(Permission.new(:name => 'mark_ticket'))
user.permissions.push(Permission.new(:name => 'do_ticket'))
user.permissions.push(Permission.new(:name => 'create_comment'))
user.permissions.push(Permission.new(:name => 'manage_users'))
user.permissions.push(Permission.new(:name => 'view_all_tickets'))
user.permissions.push(Permission.new(:name => 'view_firm_tickets'))
user.permissions.push(Permission.new(:name => 'undo_firm_tickets'))
user.permissions.push(Permission.new(:name => 'view_firms'))
user.permissions.push(Permission.new(:name => 'change_ticket_status'))
user.permissions.push(Permission.new(:name => 'view_comments'))
user.permissions.push(Permission.new(:name => 'manage_roles'))