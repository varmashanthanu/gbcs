class MembersController < ApplicationController

  # def join
  #   @invite = Invite.find(params[:id])
  #   if @invite.team.is_member(@invite.user)
  #     @invite.destroy #TODO This line should be removed as production version will not have to check for member at this stage
  #     respond_to do |format|
  #       format.html { redirect_to user_dashboard_path, notice: "You are already a member of #{@invite.team.name}." }
  #       format.js { flash[:notice] = "You are already a member of #{@invite.team.name}."
  #                   render action: 'error'}
  #     end
  #   else
  #     @member = Member.new(user:@invite.user,team:@invite.team)
  #       if @member.save
  #         @invite.destroy
  #         respond_to do |format|
  #           format.html { redirect_to user_dashboard_path}
  #           format.js { flash[:notice] = "You have joined team #{@invite.team.name}." }
  #         end
  #       end
  #   end
  #
  # end

  def new
    @member = Member.new
    @team = Team.find(params[:team])
    @students = User.students.active.order(:fname)
  end

  def create
    @member = Member.new(member_params)
    if Team.find(@member.team.id).users.exists?@member.user_id
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "#{@member.user.name} has already been added to #{@member.team.name}"
        render action: 'error'}
      end
    elsif @member.save
      @team = @member.team
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "#{@member.user.name} is added to #{@member.team.name}."}
      end
    end
  end

  def mass_add
    @team = Team.find(params[:team])
    @users = User.where(:id=>params[:members]).where.not(:id=>@team.members.pluck(:user_id))
    @users.each do |user|
      Member.create(team:@team,user:user) unless @team.users.exists?user.id
    end
    respond_to do |format|
      format.html
      format.js { flash[:notice] = 'All members successfully added.'}
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @team = @member.team
    @member.destroy
    @team.skill_update
    respond_to do |format|
      format.html
      format.js { flash[:notice] = "Removed from team #{@team.name}." }
    end
  end

  def member_params
    params.require(:member).permit(:user_id, :team_id)
  end

end
