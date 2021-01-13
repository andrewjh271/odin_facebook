class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :custom_authenticate_user!, only: :index
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :require_author!, except: [:index, :show, :new, :create]

  # GET /posts
  # GET /posts.json
  def index
    @post = Post.new
    timeline_author_ids = current_user.friends.pluck(:id) << current_user.id
    @posts = Post.where('author_id IN (?)', timeline_author_ids)
                 .order(created_at: :desc)
                 .includes(:likes, comments: :comments, author: { avatar_attachment: :blob })
                 .with_attached_photo
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    # not sure that this preloading is effective for a single record
    @post = Post.includes(
                   :likes,
                   comments: [
                     :likes,
                     author: { avatar_attachment: :blob},
                     comments: [
                        :likes,
                        author: { avatar_attachment: :blob }
                     ]
                   ]
                 )
                .find(params[:id])
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
      params.require(:post).permit(:body, :photo)
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
