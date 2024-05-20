class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  # GET /users or /users.json
  def index
    @users = User.all
    render json:@users,status: :ok
  end

  # GET /users/1 or /users/1.json
  def show
  end

  def options
    head :ok
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    Rails.logger.info("User: #{@user}")
      if @user.save
        
        render json:{user:@user},status: :created
      else
       
         render json:{errors:@user.errors.full_messages},status: :unprocessable_entity
         end
  end

   def destroy_all
    User.destroy_all
    head :no_content
  end


  # dont forget to add this method to the controller

   def login
    user = User.find_by(email: params[:user][:email])
    Rails.logger.info("User: #{user}")
    Rails.logger.info(" From User: #{params[:user][:email]}")
    if user && user.authenticate(params[:user][:password])
      render json: user
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end


  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        
        render.json:@user,status: :updated
      else
        render json:{errors:@user.errors.full_messages},status: :unprocessable_entity
       
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
