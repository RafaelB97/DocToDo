class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy, :destroyFromGroup]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = current_user.invitations
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to @invitation, notice: 'Invitation was successfully created.' }
        format.json { render :show, status: :created, location: @invitation }
      else
        format.html { render :new }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to groups_path, notice: 'Invitation was successfully updated.' }
        format.json { render :show, status: :ok, location: @invitation }
      else
        format.html { render :edit }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { render action: :show }
      format.json { head :no_content }
    end
  end

  def addUser
    puts invitation_params
    user = User.where(email: invitation_params[:email]).take
    if user
      if user != current_user
        inList = Invitation.where(user: user, group_id: invitation_params[:group_id]).take
        if inList
          puts "Already in list"
          render json: { msg: "User already in list" }, status: 406
        else
          @invitation = Invitation.new
          @invitation.group_id = invitation_params[:group_id]
          @invitation.user = user
          @invitation.status = 0

          respond_to do |format|
            if @invitation.save
              format.html { redirect_to @invitation, notice: 'Invitation was successfully created.' }
              format.json { render :show, status: :created, location: @invitation }
            else
              format.html { render :new }
              format.json { render json: @invitation.errors, status: :unprocessable_entity }
            end
          end
        end
      else
        puts "Current user not allowed"
        render json: { msg: "Current user not allowed" }, status: 406
      end
    else
      puts "User not found"
      # render :json => true, :status => 404
      render json: { msg: "User not found" }, status: 404
    end
  end

  def destroyFromGroup
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invitation_params
      params.require(:invitation).permit(:status, :user_id, :group_id, :email)
    end
end
