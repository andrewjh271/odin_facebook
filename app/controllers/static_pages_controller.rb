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
end