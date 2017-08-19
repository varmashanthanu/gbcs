class UserSkillsController < ApplicationController
  before_action :check_owner, only: [:update]

  def create
    @user_skill = UserSkill.new(user_skills_params)
    @user_skill.level = user_skills_params[:level].to_i
    @user = @user_skill.user
    @user_skill.save
    @user.update_attribute(:score,current_user.calc_score)
    @user.teams.each do |t|; t.skill_add(current_user) ; end
    respond_to do |format|
      format.html { redirect_to dashboard_users_path }
      format.js
    end
  end

  def update
    @user_skill = UserSkill.find(params[:id])
    @user = @user_skill.user
    params[:user_skill][:level] == 'on' ? @user_skill.destroy : @user_skill.update_attributes(user_skills_params)

    @user.update_attribute(:score,current_user.calc_score)
      @user.teams.each do |t|; t.skill_update ; end #FIX TODO
      respond_to do |format|
        format.html { redirect_to dashboard_users_path }
        format.js
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
