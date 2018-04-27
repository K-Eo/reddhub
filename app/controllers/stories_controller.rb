class StoriesController < ApplicationController
  before_action :set_story, except: [:new, :create, :index]
  before_action :authenticate_user!, except: [:show]

  # GET /stories
  # GET /stories.json
  def index
    @stories = policy_scope(Story).page(params[:page])
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    authorize @story
  end

  # GET /stories/new
  def new
    @story = Story.new
    authorize @story
  end

  # GET /stories/1/edit
  def edit
    authorize @story
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = current_user.stories.create(story_params)
    authorize @story

    respond_to do |format|
      if @story.save(context: :with_content)
        format.html { redirect_to @story, notice: "Story was successfully created." }
        format.json { render :show, status: :created, location: @story }
        format.js
      else
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
        format.js
      end
    end
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

  def content
    @story.content = story_params[:content]
    respond_to do |format|
      if @story.save(context: :with_content)
        format.json { render :show, status: :ok, location: @story }
      else
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def meta
    @story.title = story_params[:title]
    @story.save(context: :with_meta)
    respond_to do |format|
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
      params.require(:story).permit(:title, :content)
    end
end
