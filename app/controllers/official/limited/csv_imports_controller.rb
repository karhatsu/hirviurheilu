class Official::Limited::CsvImportsController < Official::Limited::LimitedOfficialController
  include CsvImportsHelper

  before_action :assign_race_by_race_id, :require_three_sports_race, :check_assigned_race_without_full_rights,
                :assign_race_right, :set_limited_official, :set_limited_official_csv_import

  def new
  end

  def create
    import_csv
  end

  private

  def set_limited_official_csv_import
    @limited_csv_import = true
  end

  def create_csv_import
    CsvImport.new @race, params[:file].tempfile.path, @race_right.club.try(:name)
  end

  def redirect_path_after_csv_import
    new_official_limited_race_competitor_path(@race)
  end
end
