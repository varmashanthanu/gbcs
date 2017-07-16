class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :show]
  before_action :check_authorization, only: [:edit, :update]
  # before_action :set_address, only: [:edit]
  before_action :set_user, only: [:show, :edit, :update], except: [:edit_password]
  before_action :store_current_location

  skip_before_filter :verify_authenticity_token, :only => :update_avatar

  def index
    @users = search_params
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
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_password
    @user = current_user
  end

  def edit_avatar
    @user = current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @user.update(user_params)
      if user_params[:avatar].present?
        respond_to do |format|
          format.html { redirect_back(fallback_location: @user)}
          format.js { flash[:notice] = 'Avatar Updated.'
                    render action: 'update_avatar'}
        end
      else
        respond_to do |format|
          format.html
          format.js { flash[:notice] = 'Profile Updated.' }
        end
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Update Failed.'}
      end
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
    params.require(:user).permit(:admin, :program, :graduation, :current_password, :password, :password_confirmation, :avatar, :fname, :lname, :email, :telno, :term, :active, address_attributes: [:id, :addr, :addressable_type, :addressable_id])
  end

  def store_current_location
    session[:return_to] ||= request.referer
  end

  def search_params #TODO remove loggers
    user = User.students
    (user = user.where("fname iLIKE ? OR lname iLIKE ?", "%#{params[:name]}%", "%#{params[:name]}%");Rails.logger.debug("Triggered 3")) if (params[:name] && params[:name] != '')
    current_user.admin ? user = user.students.order(:program).order(score:'DESC') : user = user.gen_sort(current_user)

    params.each do |k,v|
      Rails.logger.debug("Key #{k}, Value #{v}")
    end
    if (params[:name] && params[:name] != '') || (params[:sp].present? && (params[:sp][:sp1].present? || params[:sp][:sp2].present? || params[:sp][:sp3].present?))
      if params[:sp].present? && (params[:sp][:sp1].present? || params[:sp][:sp2].present? || params[:sp][:sp3].present?)
        user = User.search(params[:sp],params[:so])
        Rails.logger.debug("Triggered 1 #{user.class}")
      end
    end
    current_user.admin ? user : user - [current_user]
  end

end
