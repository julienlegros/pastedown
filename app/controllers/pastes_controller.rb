class PastesController < ApplicationController
  def index
    @pastes = Paste.order(created_at: :desc).page params[:page]

    # truncate
    @pastes.each do |paste|
      limit = 250
      if paste.body.length > limit
        paste.truncated = true
      else
        paste.truncated = false
      end
      paste.body = paste.body.slice(0, limit)
    end

    response = markdown_http_request @pastes
    @pastes_html = JSON.parse(response.body)["array"]
    @typo_class = 'foghorn'
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

    single_markdown_to_html

    @typo_class = 'foghorn'
  end

  def preview
    @paste = Paste.new(paste_params)

    single_markdown_to_html

    render json: { :output => @markdown_html }
  end

  private
    def paste_params
      params.require(:paste).permit(:title, :body, :gfm)
    end

    def single_markdown_to_html
      response = markdown_http_request @paste
      @markdown_html = JSON.parse(response.body)["array"][0]["output"]
    end

    def markdown_http_request (body)
      uri = URI('http://localhost:3000/api/markdown')
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})

      request.body = body.to_json
      response = http.request(request)
    end
end
