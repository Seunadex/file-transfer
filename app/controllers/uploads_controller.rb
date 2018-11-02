class UploadsController < ApplicationController
  before_action :set_upload, only: %i[destroy]
  def index
    files = []
    Upload.all.each { |u| u.files.each { |f| files << { id: f.record.id, title: f.record.title, file: f, filename: f.filename.to_s } } }
    @files = files.uniq { |f| f[:filename] }
  end

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)


    if @upload.save
      redirect_to root_path
      flash[:success] = "File successfully uploaded"
    else
      @upload.files.purge_later
      redirect_to root_path
      flash[:danger] = "An error occurred. Please try again."
    end
  end

  def destroy
    @file.destroy
    @file.files.purge_later
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      flash[:success] = "File successfully deleted"
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:title, files: [])
  end

  def set_upload
    @file = Upload.find(params[:id])
  end
end
