require "spec_helper"

describe Admin::ClubsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/admin/clubs" }.should route_to(:controller => "admin/clubs", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/admin/clubs/new" }.should route_to(:controller => "admin/clubs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/clubs/1" }.should route_to(:controller => "admin/clubs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/clubs/1/edit" }.should route_to(:controller => "admin/clubs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/clubs" }.should route_to(:controller => "admin/clubs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/clubs/1" }.should route_to(:controller => "admin/clubs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/clubs/1" }.should route_to(:controller => "admin/clubs", :action => "destroy", :id => "1")
    end

  end
end
