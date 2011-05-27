require "digest"

class User < ActiveRecord::Base
  validates_uniqueness_of :email
  validates_presence_of :encrypted_password
  validates_confirmation_of :encrypted_password
  belongs_to :role
  belongs_to :organization
  has_many :answers
  has_many :answer_details
  default_scope :order => 'registered_at DESC, users.id ASC'  

   delegate :permissions, :to => :role
  
  def authorized_for_read?
   return false unless current_user
  current_user.is_an_admin_or_operator?
end

def authorized_for_delete?
  return false unless current_user
  current_user.is_an_admin_or_operator?
end

  def self.authenticate(login, pass)
     @user = find(:first, :conditions => {:email => login})
     return nil unless @user
     @encrypted_password = Digest::MD5.hexdigest(@user.salt + pass)
     return @user if @user.encrypted_password == @encrypted_password
     return nil
  end

  def to_label
    email
  end
   # Setup the salt value and hash the password before we save everything to the
  # database.
  def before_save
    if (self.salt == nil)
      self.registered_at = Time.now
      self.salt = random_numbers(5)
      self.encrypted_password = Digest::MD5.hexdigest(self.salt + self.encrypted_password)
      self.confirmation_token = Digest::MD5.hexdigest(self.salt + self.email)
    end
  end
 
  private
 
  # A sequence of random numbers with no skewing of range in any particular
  # direction and leading zeros preserved.
  def random_numbers(len)
    numbers = ("0".."9").to_a
    newrand = ""
    1.upto(len) { |i| newrand << numbers[rand(numbers.size - 1)] }
    return newrand
  end
  public
  ##��������� ������ ��� ����, ����� ��������  ��������� user.is_admin? user.can_dance_or_fly? ��������� � ��������� ��-� �� ������ roles � permissions
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
