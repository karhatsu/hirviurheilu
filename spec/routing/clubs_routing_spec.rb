require "spec_helper"

describe ClubsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/clubs" }.should route_to(:controller => "clubs", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/clubs/new" }.should route_to(:controller => "clubs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/clubs/1" }.should route_to(:controller => "clubs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/clubs/1/edit" }.should route_to(:controller => "clubs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/clubs" }.should route_to(:controller => "clubs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/clubs/1" }.should route_to(:controller => "clubs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/clubs/1" }.should route_to(:controller => "clubs", :action => "destroy", :id => "1")
    end

  end
end
