class Api::V1::SessionsController < Devise::SessionsController

  respond_to :json

  def create

    # Check Facebook login
    facebook_token = params[:player][:facebook_access_token]
    facebook_id = params[:player][:facebook_id]
    if !facebook_token.nil?
      facebook_login(facebook_token,facebook_id)
      return
    end

    login = params[:player][:login]
    password = params[:player][:password]
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end

    if login.nil? or password.nil?
       render :status=>400,
              :json=>{:message=>"The request must contain an email/username and password."}
       return
    end

    @player=Player.find(:first, :conditions => [ "lower(username) = ? or lower(email) = ?", login.downcase, login.downcase])

    if @player.nil?      
      render :status=>401, :json=>{:message=>"Invalid email or password."}
      return
    end

    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @player.ensure_authentication_token!

    if not @player.valid_password?(password)      
      render :status=>401, :json=>{:message=>"Invalid email or password."}
    else
      render :status=>200, :json=>{:token=>@player.authentication_token, :username => @player.username, :id => @player.id}
    end
  end
  # def create
  #   logger.info "Attempt to sign in by #{ params }"
  #   super
  # end

  def destroy
    super
  #   @player=Player.find_by_authentication_token(params[:id])
  #   if @player.nil?      
  #     render :status=>404, :json=>{:message=>"Invalid token."}
  #   else
  #     @player.reset_authentication_token!
  #     render :status=>200, :json=>{:token=>params[:id]}
  #   end
  end

  def facebook_login(facebook_token, passed_in_facebook_id)
    response = HTTParty.get(' https://graph.facebook.com/me/?access_token=' + facebook_token)
    puts response.body, response.code, response.message, response.headers.inspect

    first_name = response.parsed_response["first_name"]
    last_name = response.parsed_response["last_name"]
    facebook_id = response.parsed_response["id"]
    random_password = ('0'..'z').to_a.shuffle.first(8).join
    email = params[:player][:email]

    # Make sure the user is who they say they are
    if passed_in_facebook_id != facebook_id
       render :status=>400,
              :json=>{:message=>"Invalid Facebook session."}
       return
    end

    @player = Player.find_by_facebook_id(facebook_id)
    
    if @player.nil?

      # Merge existing account on Facebook
      @player = Player.find_by_email(email.downcase)

      # Create a new player
      if @player.nil?
        username = (first_name + last_name[0,1].to_s).downcase
        players = Player.where("username LIKE :prefix", prefix: "#{username}%")
        if players.count > 0
          count = players.count
          while true do
            username = username + count.to_s 
            existing = Player.find_by_username(username)
            if existing.nil?          
              break
            end
            count = count + 1
          end
        end

        @player = Player.create(:facebook_id => facebook_id, 
          :facebook_access_token => facebook_token,
          :email => email.downcase,
          :first_name => first_name,
          :last_name => last_name,
          :username => username,
          :password => random_password)
      else
        #update an exisiting one
        @player.facebook_id = facebook_id
        @player.facebook_access_token = facebook_token
        @player.first_name = first_name
        @player.last_name = last_name
        @player.save
      end
    end

    @player.ensure_authentication_token!
    render :status=>200, :json=>{:token=>@player.authentication_token, :username => @player.username, :id => @player.id}

  end

end
