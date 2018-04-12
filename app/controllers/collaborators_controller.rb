class CollaboratorsController < ApplicationController
  before_action :force_json, only: :autocomplete
  def autocomplete
    users = User.ransack(username_cont: params[:q]).result
    wiki = Wiki.find(params[:wiki_id])
    @users = non_collaborating_users(wiki,users)
  end

  def create
    @collaborator = Collaborator.new(collaborator_params)
    if params[:q]
      user = User.find_by_username(params[:q])
      @collaborator.user_id = user.id
    end
    authorize @collaborator

    if @collaborator.save
      user = User.find(@collaborator.user_id)
      flash[:notice] = "Added #{user.username} to the collaborators list."
    else
      flash.now[:alert] = 'There was an error adding a collaborator.'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator

    if @collaborator.destroy
      user = User.find(@collaborator.user_id)
      flash[:notice] = "Removed #{user.username} removed from collaborators list."
    else
      flash.now[:alert] = 'There was an error removing the collaborator.'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def collaborator_params
    params.require(:collaborator).permit(:user_id, :wiki_id)
  end

  def non_collaborating_users(wiki, users)
    filtered_users = []
    users.each do |user|
      filtered_users << user unless (user == wiki.user || wiki.collaborating_users.include?(user))
    end
    filtered_users.sort_by { |u| u.username.downcase }
  end

  def force_json
    request.format = :json
  end
end
