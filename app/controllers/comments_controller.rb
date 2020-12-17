class CommentsController < ApplicationController
  def new
    @post = Post.find(params[:post_id])
    @autofocus = true;
    render 'posts/show'
  end

  def create
    comment = current_user.comments.build(comment_params)
    flash.alert = "Error: #{comment.errors.full_messages.join}" unless comment.save
    redirect_to post_url(comment.get_post_or_photo_id, anchor: "comment-#{comment.id}")
  end

  def edit
    @post = Post.find(params[:post_id])
    @edit = params[:id].to_i
    render 'posts/show'
  end

  def update
    comment = Comment.find(params[:id])
    flash.alert = "Error: #{comment.errors.full_messages.join}" unless comment.update(comment_params)
    redirect_to post_url(comment.get_post_or_photo_id, anchor: "comment-#{comment.id}")
  end

  def new_reply
    @comment = Comment.find(params[:comment_id])
    @post = Post.find(@comment.get_post_or_photo_id)
    @reply_to = params[:comment_id].to_i
    render 'posts/show'
  end

  def edit_reply

  end

  def destroy
    comment = Comment.find(params[:id])
    url = post_url(comment.get_post_or_photo_id)
    comment.destroy
    redirect_to url
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end