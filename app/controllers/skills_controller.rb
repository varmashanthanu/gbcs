class SkillsController < ApplicationController
  before_action :check_admin

  def index
    @skills = Skill.all
  end

  def show
    @skill = Skill.find(params[:id])
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      redirect_to @skill, notice: 'New Skill Created.'
    else
      redirect_back(fallback_location:skills_new_path, notice:'Failed. Please try Again.')
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
  def check_admin
    unless current_user.admin
      redirect_to current_user, notice: 'Administrator-only Action.'
    end
  end

  def skill_params
    params.require(:skill).permit(:name,:group,:weight)
  end
end
