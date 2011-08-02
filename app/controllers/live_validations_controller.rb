class LiveValidationsController < ApplicationController
  def validate_username
    if params[:username].length > 3
      @user = User.find_by_username(params[:username])
      if @user.nil?
        @message = "<img src='/images/accept.png' alt='Valid Username'/>"
      else
        @message = "<img src='/images/cross.png' alt='Invalid Username' /> Name taken"
      end
    else
      @message = ""
    end
    render :partial => "message"
  end
  
  
  def validate_details
  @message = 'no details' if not params[:details]
    if params[:details].length < 3
#<img src='/images/cross.png' alt='Invalid Username' />
        @message = " Name taken"
    else
      @message = "ok"
    end
    render :partial => "message"
  end
end
