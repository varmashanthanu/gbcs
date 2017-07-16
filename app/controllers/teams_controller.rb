class TeamsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]
  before_action :check_lead, only: [ :edit, :update, :destroy]


  def index
    current_user.admin ? @teams = Team.order(:created_at) : @teams = Team.skill_match(current_user)
  end

  def mine
    @teams = Team.mine(current_user)
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new(lead_id:current_user.id)
    @team.comp_teams.new
  end

  def create
    @team = Team.new(teams_params)
    if @team.save
      unless current_user.admin
        Member.create(team:@team,user:current_user)
        @team.skill_add(current_user)
      end
      if @team.comp_teams_attributes
        @team.comp_teams_attributes.first[1].each do | k,v| #TODO WTF is going on here?
          Rails.logger.debug(v)
          if v.to_i>0
            @team.comp_teams.create(competition_id:v.to_i)
          end
        end
        # Rails.logger.debug(@team.comp_teams_attributes.first[1].each do |k,v|; )
      end
      respond_to do |format|
        format.html { redirect_to @team, notice: 'Team Created' }
        format.js { flash[:notice] = 'Team Created' }
      end
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(teams_params)
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def destroy
    @team = Team.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to teams_path, notice: 'Deleted.' }
      format.js { flash[:notice] = 'Deleted.' }
    end
  end

  private
  def check_lead
    Team.find(params[:id]).is_lead(current_user)
  end

  def check_member
    Team.find(params[:id]).is_member(current_user)
  end

  def teams_params
    params.require(:team).permit(:name,:avatar,:lead_id, comp_teams_attributes: [:competition_id])
  end

  def member_params
    params.require(:member).permit(:user,:team_id,:id)
  end
end
