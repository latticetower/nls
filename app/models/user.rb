require "digest"

class User < ActiveRecord::Base
  validates_uniqueness_of :email
  validates_presence_of :encrypted_password
  validates_confirmation_of :encrypted_password
  belongs_to :role
  belongs_to :organization
  
   delegate :permissions, :to => :role
  
  def self.authenticate(login, pass)
     @user = find(:first, :conditions => {:email => login})
     @encrypted_password = Digest::MD5.hexdigest(@user.salt + pass)
     return @user if @user.encrypted_password == @encrypted_password
     return null
  end

  def to_label
    email
  end
   # Setup the salt value and hash the password before we save everything to the
  # database.
  def before_save
    if (self.salt == nil)
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
  ##следующие методы для того, чтобы работали  выражения user.is_admin? user.can_dance_or_fly? выражения в контексте зн-й из таблиц roles и permissions
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
