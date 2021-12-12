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
        send_emails import
        flash[:success] = 'Kilpailut tallennettu palveluun'
        redirect_to official_root_path
      else
        @errors = import.errors
        render :new
      end
    end
  end

  private

  def send_emails(import)
    import.existing_users.keys.each do |user|
      ImportMultipleRacesMailer.races_assigned_to_existing_user(current_user, user, import.existing_users[user]).deliver_now
    end
    import.new_emails.keys.each do |email|
      ImportMultipleRacesMailer.races_assigned_to_new_user(current_user, email, import.new_emails[email]).deliver_now
    end
  end
end
