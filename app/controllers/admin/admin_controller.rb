class Admin::AdminController < ApplicationController
  before_action :require_user, :check_rights, :set_admin
  layout 'admin'

  protected
  def check_rights
    redirect_to root_path unless current_user.admin?
  end

  def set_admin
    @is_admin = true
  end
end