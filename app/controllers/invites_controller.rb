class InvitesController < ApplicationController

  def new
    @invite = Invite.new
    params.each do |k,v|
      Rails.logger.debug(k)
      Rails.logger.debug(v)
    end
    @team = Team.find(params[:team])
    # Rails.logger.debug("test #{params[:team_id]}")
  end

  def create
    @invite = Invite.new(invite_params)
    if Invite.duplicate(@invite).present?
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "#{@invite.user.name} has already been invited to join #{@invite.team.name}"
                    render action: 'error'}
      end
    elsif @invite.save
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "An invitation has been sent to #{@invite.user.name}."}
      end
    end
  end

  def mass_invite
    @team = Team.find(params[:team])
    @users = User.where(:id=>params[:members]).where.not(:id=>@team.members.pluck(:user_id))
    Rails.logger.debug(@users.pluck(:id))
    @users.each do |user|
      @invite = @team.invites.new(sender_id:current_user.id,user:user)
      @invite.save unless Invite.duplicate(@invite).present?
    end
    respond_to do |format|
      format.html
      format.js { flash[:notice] = 'Invites sent.'}
    end
  end

  def destroy
    @invite = Invite.destroy(params[:id])
    respond_to do |format|
      format.html
      format.js { flash[:notice] = 'Invitation has been removed.' }
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:sender_id, :user_id, :team_id)
  end

end
