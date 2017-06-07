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
      respond_to do |format|
        format.html { redirect_to skills_url, notice: 'Added' }
        format.js { flash[:notice] = 'Added' }
      end
    elsif @skill.duplicate
      respond_to do |format|
        format.html { redirect_back(fallback_location:new_skill_path, notice:'Skill is Duplicate.') }
        format.js { flash[:notice] = 'Skill is Duplicate.'
                    render action: "error" }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location:new_skill_path, notice:'Failed. Please try Again.') }
        format.js { flash[:notice] = 'Failed. Please try Again.'
                    render action: "error"}
      end
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
