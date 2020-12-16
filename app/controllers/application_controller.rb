class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :about

  def about
    render 'shared/about'
  end
end
