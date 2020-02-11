class Official::CsvImportsController < Official::OfficialController
  include CsvImportsHelper

  before_action :assign_race_by_race_id, :check_assigned_race

  def new
  end

  def create
    import_csv
  end

  private

  def create_csv_import
    CsvImport.new @race, params[:file].tempfile.path
  end

  def redirect_path_after_csv_import
    official_race_path(@race)
  end
end
