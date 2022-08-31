class Official::CsvExportsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_csv

  def show
  end

  def create
    send_data(RaceCsvExport.new(@race, params[:all_data]).data, type: 'text/csv', filename: 'kilpailijat.csv')
  end

  private
  def set_csv
    @is_csv = true
  end
end
