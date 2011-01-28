class ModesController < ApplicationController
  def update
    Mode.switch
    redirect_to root_path
  end
end
