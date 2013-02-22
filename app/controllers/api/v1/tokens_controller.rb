class Api::V1::TokensController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  # def create
  #   email = params[:email]
  #   password = params[:password]
  #   if request.format != :json
  #     render :status=>406, :json=>{:message=>"The request must be json"}
  #     return
  #   end

  #   if login.nil? or password.nil?
  #      render :status=>400,
  #             :json=>{:message=>"The request must contain an email/username and password."}
  #      return
  #   end

  #   @player=Player.find_by_email(email.downcase)

  #   if @player.nil?      
  #     render :status=>401, :json=>{:message=>"Invalid email or password."}
  #     return
  #   end

  #   # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
  #   @player.ensure_authentication_token!

  #   if not @player.valid_password?(password)      
  #     render :status=>401, :json=>{:message=>"Invalid email or password."}
  #   else
  #     render :status=>200, :json=>{:token=>@player.authentication_token}
  #   end
  # end
  def create
    logger.info "Attempt to sign in by #{ params[:user][:login] }"
    super
  end

  def destroy
    @player=Player.find_by_authentication_token(params[:id])
    if @player.nil?      
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @player.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end
end
