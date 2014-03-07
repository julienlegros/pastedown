class HomeController < ApplicationController
  def index
    @paste = Paste.new
  end
end
