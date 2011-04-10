class Admin::AdminController < ApplicationController
  before_filter :require_user, :check_rights, :set_admin
  layout 'admin'

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  end

  protected
  def check_rights
    redirect_to root_path unless current_user.admin?
  end

  def set_admin
    @is_admin = true
  end
end