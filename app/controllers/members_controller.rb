class MembersController < ApplicationController

  def join
    @invite = Invite.find(params[:id])
    if @invite.team.is_member(@invite.user)
      @invite.destroy #TODO This line should be removed as production version will not have to check for member at this stage
      respond_to do |format|
        format.html { redirect_to user_dashboard_path, notice: "You are already a member of #{@invite.team.name}." }
        format.js { flash[:notice] = "You are already a member of #{@invite.team.name}."
                    render action: 'error'}
      end
    else
      @member = Member.new(user:@invite.user,team:@invite.team)
        if @member.save
          @invite.team.skill_add(@invite.user)
          @invite.destroy
          respond_to do |format|
            format.html { redirect_to user_dashboard_path}
            format.js { flash[:notice] = "You have joined team #{@invite.team.name}." }
          end
        end
    end

  end

  def destroy
    @member = Member.find(params[:id])
    team = @member.team
    user = @member.user
    @member.destroy
    team.skill_delete(user)
    if team.is_lead(current_user)
      team.members.any? ? team.update(lead_id:team.members.first.user.id):team.destroy
      # TODO Move logic to model.^^
    end
    respond_to do |format|
      format.html
      format.js { flash[:notice] = "You have left team #{team.name}" }
    end
  end

end
