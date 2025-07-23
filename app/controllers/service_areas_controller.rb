class ServiceAreasController < ApplicationController
  def index
    @libraries = Library.all

    @service_areas = if params[:library_id].present?
                       ServiceArea.where(library_id: params[:library_id])
                     else
                       ServiceArea.all
                     end

    @service_areas = @service_areas.page(params[:page]) # 👈 Enable Kaminari pagination
  end

  def show
    if params[:library_id].present?
      @library = Library.find(params[:library_id])
      @service_area = @library.service_areas.find(params[:id])
    else
      @service_area = ServiceArea.find(params[:id])
    end
  end
end
