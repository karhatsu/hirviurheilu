# encoding: UTF-8
class Official::CsvImportsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race
  
  def new
  end
  
  def create
    if params[:file].blank?
      flash[:error] = 'Valitse tiedosto'
      render :new
    else
      begin
        import = CsvImport.new(@race, params[:file].tempfile.path)
        if import.save
          flash[:success] = 'Kilpailijat ladattu tietokantaan'
          redirect_to official_race_path(@race)
        else
          flash[:error] = 'Tiedostosta löytyi virheitä (yhtään kilpailijaa ei ole tallennettu tietokantaan):<br/>'
          flash[:error] += import.errors.join('<br/>')
          render :new
        end
      rescue UnknownCSVEncodingException
        flash[:error] = "Tiedoston merkistökoodausta ei pystytty tunnistamaan. "
        flash[:error] += "Ole hyvä ja <a href='#{new_feedback_path}'>lähetä ongelmasta palautetta</a>."
        render :new
      end
    end
  end
end