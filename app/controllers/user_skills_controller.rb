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
    @user = @user_skill.user
    if @user_skill.duplicate(current_user)
      respond_to do |format|
        format.html { redirect_back(fallback_location:user_dashboard_path) }
        format.js { flash[:notice] = 'Skill is Duplicate.'
        render action: "error" }
      end
    elsif @user_skill.save
      @user.update_attribute(:score,current_user.calc_score)
      @user.teams.each do |t|; t.skill_update(current_user) ; end
      respond_to do |format|
        format.html { redirect_to user_dashboard_path }
        format.js { flash[:notice] = 'Skill Added.' }
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
    @user = @user_skill.user
    if @user_skill.update_attributes(user_skills_params)
      @user.update_attribute(:score,current_user.calc_score)
      @user.teams.each do |t|; t.skill_update(current_user) ; end
      respond_to do |format|
        format.html { redirect_to user_dashboard_path }
        format.js { flash[:notice] = 'Updated.' }
      end
    end
  end

  def destroy
    @user_skill = UserSkill.destroy(params[:id])
    @user = @user_skill.user
    @user.update_attribute(:score,current_user.calc_score)
    @user.teams.each do |t|; t.skill_update(current_user) ; end
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
