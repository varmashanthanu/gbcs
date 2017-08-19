class TeamsController < ApplicationController

  include TeamsHelper
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
    @view = params[:view]
  end

  def new
    @team = Team.new(lead_id:current_user.id)
  end

  def create
    @team = Team.new(teams_params)
    if @team.save
      unless current_user.admin
        Member.create(team:@team,user:current_user)
        @team.skill_add(current_user)
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

  def transfer
    if member[:m].transfer(member[:o],member[:n])
      @user = member[:u]
      @old_team = member[:o]
      @new_team = member[:n]
      # @change = Hash.new
      # @change = {:user => member[:u],:old => member[:o],:new => member[:n]}
      respond_to do |format|
        format.js { flash[:notice] = "Transferred #{member[:u].fname} from #{member[:o].name} to #{member[:n].name}." }
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
    params.require(:team).permit(:name,:avatar,:lead_id)
  end

  def member
    old_team_id = params[:old_team].split('_').last.to_i
    user_id = params[:user].split('_').last.to_i
    new_team_id = params[:new_team].split('_').last.to_i
    user = User.find(user_id)
    new_team = Team.find(new_team_id)
    old_team = Team.find(old_team_id)
    member = Member.where(team:old_team,user:user).first
    {o: old_team, n: new_team, u: user, m: member}
  end
end
