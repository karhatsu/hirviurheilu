class CupsController < ApplicationController
  before_action :assign_cup_by_id

  def show
    @is_cup = true
    @is_cup_main = true
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf do
        @page_breaks = params[:page_breaks]
        render :pdf => "#{@cup.name} - tulokset", :layout => true,
               :margin => pdf_margin, :header => pdf_header("#{@cup.name} - Tuloskooste"), :footer => pdf_footer,
               :orientation => 'Landscape', disable_smart_shrinking: true
      end
    end
  end
end
