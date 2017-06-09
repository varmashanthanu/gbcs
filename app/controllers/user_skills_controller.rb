class UserSkillsController < ApplicationController
  before_action :check_owner, only: [:edit, :destroy, :update]
  def index
    @user_skills = current_user.user_skills
  end

  def new
    @user_skill = UserSkill.new(user:current_user)
  end

  def create
    @user_skill = UserSkill.new(user_skills_params)
    if @user_skill.save
      respond_to do |format|
        format.html { redirect_to user_dashboard_path }
        format.js { flash[:notice] = 'Skill Added.' }
      end
    elsif @user_skill.duplicate(current_user)
      respond_to do |format|
        format.html { redirect_back(fallback_location:user_dashboard_path) }
        format.js { flash[:notice] = 'Skill is Duplicate.'
        render action: "error" }
      end
    else
    respond_to do |format|
      format.html { redirect_back(fallback_location:user_dashboard_path) }
      format.js { flash[:notice] = 'Failed. Please try Again.'
      render action: "error"}
      end
    end
  end

  def edit
    @user_skill = UserSkill.find(params[:id])
  end

  def update
    @user_skill = UserSkill.find(params[:id])
    if @user_skill.update_attributes(user_skills_params)
      respond_to do |format|
        format.html { redirect_to user_dashboard_path }
        format.js { flash[:notice] = 'Updated.' }
      end
    end
  end

  def destroy
    @user_skill = UserSkill.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to user_dashboard_path }
      format.js { flash[:notice] = 'Deleted.' }
    end
  end

  private

  def user_skills_params
    params.require(:user_skill).permit(:skill_id, :user_id, :level)
  end

  def check_owner

      redirect_to user_dashboard_path, notice: 'Authorization Error' if UserSkill.find(params[:id]).user != current_user

  end
end
