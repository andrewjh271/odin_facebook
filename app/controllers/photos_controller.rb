class PhotosController < ApplicationController
  def new

  end

  def create

  end

  def show
    @photo = ActiveStorage::Attachment.find(params[:id])
  end

  def destroy

  end
end