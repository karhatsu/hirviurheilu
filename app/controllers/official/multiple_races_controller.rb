class Official::MultipleRacesController < Official::OfficialController
  def new
  end

  def create
    if params[:file].blank?
      flash[:error] = 'Valitse tiedosto'
      render :new
    elsif !params[:file].original_filename.end_with? '.csv'
      flash[:error] = 'Tiedostopääte pitää olla .csv'
      render :new
    else
      flash[:error] = nil
      import = CsvMultipleImport.new current_user, params[:file].tempfile.path
      if import.errors.empty?
        flash[:success] = 'Kilpailut tallennettu palveluun'
        redirect_to official_root_path
      else
        @errors = import.errors
        render :new
      end
    end
  end
end
