require "spec_helper"

describe CompetitorsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/competitors" }.should route_to(:controller => "competitors", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/competitors/new" }.should route_to(:controller => "competitors", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/competitors/1" }.should route_to(:controller => "competitors", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/competitors/1/edit" }.should route_to(:controller => "competitors", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/competitors" }.should route_to(:controller => "competitors", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/competitors/1" }.should route_to(:controller => "competitors", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/competitors/1" }.should route_to(:controller => "competitors", :action => "destroy", :id => "1")
    end

  end
end
