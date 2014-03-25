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

    to_markdown

    @typo_class = 'foghorn'
  end

  def preview
    @paste = Paste.new(paste_params)

    to_markdown

    render json: { :output => @markdown_html }
  end

  private
    def paste_params
      params.require(:paste).permit(:title, :body)
    end

    def to_markdown
      uri = URI('http://localhost:3000/api/markdown')

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
      request.body = @paste.to_json

      response = http.request(request)
      @markdown_html = JSON.parse(response.body)["output"]
    end
end
