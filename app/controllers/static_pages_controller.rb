class StaticPagesController < ApplicationController
  def about
  end

  def search
    @query = params[:query].downcase
    @users = User.where('LOWER(name) LIKE ?', "%#{@query}%")
                 .order(:name)
    @posts = Post.where('LOWER(body) LIKE ?', "%#{@query}%")
                 .order(created_at: :desc)
  end

  def odin_invincible
  end

  def odin_immutable
  end
end