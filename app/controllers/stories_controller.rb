class StoriesController < ApplicationController
  before_action :set_story, except: [:new, :index, :preview]
  before_action :authenticate_user!, except: [:show]

  # GET /stories
  # GET /stories.json
  def index
    @stories = policy_scope(Story).page(params[:page])

    if params[:scope] == "public"
      @stories = @stories.published
    else
      @stories = @stories.drafts
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    authorize @story
  end

  # GET /stories/new
  def new
    @story = current_user.stories.create
    authorize @story
    @story.save
    redirect_to edit_story_path(@story)
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    authorize @story
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to edit_story_path(@story), notice: "Story was successfully updated." }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /stories/1/edit
  def edit
    authorize @story
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    authorize @story
    @story.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: "Story was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def preview
    respond_to do |format|
      format.js
    end
  end

  def publish
    @story.publish
    respond_to do |format|
      format.html { redirect_to @story, notice: "Story has been published." }
      format.json { render :show, status: :ok, location: @story }
      format.js
    end
  end

  def unpublish
    @story.unpublish
    respond_to do |format|
      format.html { redirect_to @story, notice: "Story has been unpublised." }
      format.json { render :show, status: :ok, location: @story }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :subtitle, :content)
    end
end
