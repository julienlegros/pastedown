class PastesController < ApplicationController
  def index
    @pastes = Paste.all
  end

  def new
    @paste = Paste.new
  end

  def create
    @paste = Paste.new(paste_params)
    if @paste.save
      redirect_to @paste
    else
      render "home/index"
    end
  end

  def show
    @paste = Paste.find(params[:id])
  end

  private
    def paste_params
      params.require(:paste).permit(:title, :body)
    end
end
