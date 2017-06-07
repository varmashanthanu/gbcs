class SkillsController < ApplicationController
  before_action :check_admin

  def index
    @skills = Skill.order(category:'ASC').order(name:'ASC')
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
        format.html { redirect_to skills_url }
        format.js { flash[:notice] = 'Added' }
      end
    elsif @skill.duplicate
      respond_to do |format|
        format.html { redirect_back(fallback_location:new_skill_path) }
        format.js { flash[:notice] = 'Skill is Duplicate.'
                    render action: "error" }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location:new_skill_path) }
        format.js { flash[:notice] = 'Failed. Please try Again.'
                    render action: "error"}
      end
    end

  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def update
    @skill = Skill.find(params[:id])
    Rails.logger.debug('Triggered Update')
    if @skill.update_attributes(skill_params)
      Rails.logger.debug('Triggered if in update')
      respond_to do |format|
        format.html { redirect_to skills_url }
        format.js { flash[:notice] = 'Updated' }
      end
    end
  end

  def destroy
    @skill = Skill.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to skills_url }
      format.js
    end
  end

  private
  def check_admin
    unless current_user.admin
      redirect_to current_user, notice: 'Administrator-only Action.'
    end
  end

  def skill_params
    params.require(:skill).permit(:name,:category,:weight)
  end
end
