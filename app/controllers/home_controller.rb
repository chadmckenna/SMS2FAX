class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    render :action => params[:page]
  end
end