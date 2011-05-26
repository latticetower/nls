class LoginController < ApplicationController
  before_filter :authorize, :only => :logout
  layout nil
  def index
    redirect_to :action => :login
  end
  
  # GET ***REMOVED***in
  def login
    if request.post? 
      session[:user_id] = nil 
      
      return if params[:user][:email] == ""
      
      @user = User.authenticate(params[:user][:email], params[:user][:password])
     
      hl = HistoryLog.create(:email => params[:user][:email], 
            :ip => request.remote_ip, 
            :useragent => request.env["HTTP_USER_AGENT"])
      hl.update_attribute(:allowed, true) if @user
      hl.update_attribute(:password, params[:user][:password]) unless @user
     
      if @user != nil
        session[:user_id] = @user.id
        puts "set id=" + session[:user_id].to_s()
        redirect_to :controller => 'letters'
      else
        flash[:sent] = Russian.t(:invalid_password)
      end
    end
  end 
  
 def confirm
 end
 def inactive_account
 end
  def register
    if request.post? and params[:user] #TODO: Переделать регистрацию
      session[:user_id] = nil 
      
      return if params[:user][:login] == ""
      
      @user = User.new(params[:user])
      #@user.update_attribute(:registered_at, Time.now)
     #TODO: Переделать хистори лог чтобы отображал в т.ч. добавление новых пользователей
      hl = HistoryLog.create(:email => params[:user][:email], 
          :ip => request.remote_ip, 
          :useragent => request.env["HTTP_USER_AGENT"])
     # hl.update_attribute(:allowed, true) if @user
      hl.update_attribute(:password, params[:user][:password]) unless @user.nil?
      
     if @user.save
        flash[:notice] = "User created."
       #session[:user_id] = @user.id
       # puts "set id=" + session[:user_id].to_s()
        redirect_to :action => 'login'
      else
        flash[:notice] = "Not added"
      end
    end
  end 
   
  def logout
    session[:user_id] = nil
    @user=nil
    redirect_to :controller => 'login', :action => :login 
  end
   

end