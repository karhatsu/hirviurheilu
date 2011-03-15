class Official::CsvImportsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race
  
  def new
  end
  
  def create
    import = CsvImport.new(@race, params[:file].tempfile.path)
    import.save
    flash[:success] = 'Kilpailijat ladattu tietokantaan'
    redirect_to official_race_path(@race)
  end
end