class LibrariesController < ApplicationController
  def index
   @q = Library.ransack(params[:q])
 @libraries = @q.result.includes(service_areas: :statistics).page(params[:page])
   
  end

  def show
    @library = Library.includes(service_areas: :statistics).find(params[:id])
  end
end