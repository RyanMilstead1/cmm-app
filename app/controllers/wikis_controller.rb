class WikisController < ApplicationController
  before_action :authenticate_user!

  def show
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki
    @collaborators = @wiki.collaborating_users
  end

  def index
    @wikis = policy_scope(Wiki)
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki '#{@wiki.title[0..10]}...' was created."
      redirect_to @wiki
    else
      flash.now[:alert] = 'There was an error creating the wiki.'
      render :new
    end
  end

  def edit
    @wiki = Wiki.includes(:collaborators => :user).friendly.find(params[:id])
    authorize @wiki
  end

  def update
    @wiki = Wiki.friendly.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    authorize @wiki

    if @wiki.save
      flash[:notice] = 'Wiki was updated.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'An error occured. The wiki was not updated.'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "'#{@wiki.title[0..20]}' was deleted successfully."
      redirect_to wikis_path
    else
      flash.now[:alert] = 'Error deleting the post.'
      render :index
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
