class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :show]
  before_action :check_authorization, only: [:edit, :update]
  # before_action :set_address, only: [:edit]
  before_action :set_user, only: [:edit, :update, :show]
  before_action :store_current_location

  def index
    current_user.admin ? @users = User.students : @users = User.gen_sort(current_user) - [current_user]
  end

  def show
  end

  def column_graph
    @user = User.find(params[:id])
    skill_graph = @user.skill_calc
    render json: skill_graph
  end
  def indi_graph
    @user = User.find(params[:id])
    indi_skill_graph = @user.indi_skill_calc
    render json: indi_skill_graph
  end

  def dashboard
    @user_skills = current_user.user_skills
    @user_teams = current_user.members
    @invites = Invite.received(current_user)
    @comps = Competition.where(creator_id: current_user.id)
  end

  def edit
  end

  def edit_password
    @user = current_user
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Updated'
    else
      redirect_to edit_user_path(@user), notice: 'Update failed, Please Try Again.'
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      redirect_to current_user, notice: 'Password Changed'
    else
      notice = @user.update_password_error(user_params)
      redirect_to user_edit_password_path, notice: "#{notice}"
    end
  end

  private
  def check_authorization
    unless current_user.id == params[:id].to_i
      Rails.logger.debug("#{params[:id]}")
      redirect_to root_url, notice: 'Account Ownership Error'
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # def set_address
  #   @user = User.find(params[:id])
  #   unless @user.address.present?
  #     @address = Address.create(addressable:@user)
  #   end
  # end

  def user_params
    params.require(:user).permit(:admin, :program, :graduation, :current_password, :password, :password_confirmation, :avatar, :fname, :lname, :email, :telno, address_attributes: [:id, :addr, :addressable_type, :addressable_id])
  end

  def store_current_location
    session[:return_to] ||= request.referer
  end
end
