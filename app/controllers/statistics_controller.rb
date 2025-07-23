class StatisticsController < ApplicationController
  def index
    @statistics = Statistic.all

    # Filters
    @statistics = @statistics.where("active_users >= ?", params[:min_users]) if params[:min_users].present?
    @statistics = @statistics.where("active_users <= ?", params[:max_users]) if params[:max_users].present?
    @statistics = @statistics.where(year: params[:year]) if params[:year].present?

    # Paginate (Kaminari)
    @statistics = @statistics.page(params[:page])
  end

  def show
    if params[:library_id].present? && params[:service_area_id].present?
      # Nested route: /libraries/:library_id/service_areas/:service_area_id/statistics/:id
      @library = Library.find(params[:library_id])
      @service_area = @library.service_areas.find(params[:service_area_id])
      @statistic = @service_area.statistics.find(params[:id])
    else
      # Non-nested fallback
      @statistic = Statistic.find(params[:id])
    end
  end
end
