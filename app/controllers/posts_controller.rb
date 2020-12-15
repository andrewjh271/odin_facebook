class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :custom_authenticate_user!, only: :index
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_author!, except: [:index, :show, :new, :create]

  # GET /posts
  # GET /posts.json
  def index
    @post = Post.new
    @posts = Post.all.includes(:likes, comments: [:comments]).order(created_at: :desc)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html do
          flash.now[:alert] = "Error: #{@post.errors.full_messages.join}"
          render :new
        end
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html do
          flash.now[:alert] = "Error: #{@post.errors.full_messages.join}"
          render :edit
        end
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:body)
    end

    def require_author!
      unless current_user.id == @post.author_id
        flash[:alert] = 'You are not authorized to edit this post!'
        redirect_to root_url
      end
    end

    def custom_authenticate_user!
      # avoids setting flash message for root url
      unless user_signed_in?
        flash.alert = 'You need to sign in or sign up before continuing.' unless request.env['PATH_INFO'] == '/'
        redirect_to new_user_session_path
      end
    end
end
