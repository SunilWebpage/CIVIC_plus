class SyllabusesController < ApplicationController
  def index
    @categories = Syllabus.distinct.order(:category).pluck(:category)
    allowed_filters = @categories.map(&:downcase)
    @selected_filter = params[:filter].presence_in(allowed_filters) || "all"
    @filters = [ { label: "All", value: "all" } ] + @categories.map { |category| { label: category, value: category.downcase } }

    records = Syllabus.ordered
    records = records.where("LOWER(category) = ?", @selected_filter) unless @selected_filter == "all"

    @syllabus_groups = records.group_by(&:category)
  end
end
