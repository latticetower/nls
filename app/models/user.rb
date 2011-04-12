class User < ActiveRecord::Base
  default_scope :order => 'organization_id ASC, fio ASC'
  belongs_to :organization
  belongs_to :role
  delegate :permissions, :to => :role
 

 
named_scope :by_org, lambda{ |orgs| {
	  :conditions => ['organization_id in (?)', orgs],
	  :order => "organization_id, fio"
	}} 

  named_scope :cin_users,  :conditions=> {:organization_id => 1}
   
 
		  
  ##validates_presence_of :login
  ##validates_presence_of :fio
  ##validates_presence_of :password
  validates_presence_of :organization
  ##validates_uniqueness_of :login


  
  
 
  #конец вставки
  
  def self.authenticate(login, pass)
    return find(:first, :conditions => {:login => login, :password => pass})
  end

  def to_label
    fio
  end
  
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      tokenize_roles(match.captures.first).each do |check|
        return true if role.typename.downcase == check
      end
      return false
    elsif match = matches_dynamic_perm_check?(method_id)
	  tokenize_roles(match.captures.first).each do |check|
        return true if permissions.find_by_name(check.downcase)
      end
      return false
    else
      super
    end
  end

  private
 
  def matches_dynamic_perm_check?(method_id)
    /^can_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end
  
  def matches_dynamic_role_check?(method_id)
    /^is_an?_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end
 
  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end
  
end