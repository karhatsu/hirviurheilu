# encoding: UTF-8
require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      Date.stub!(:today).and_return(Date.new(2012, 1, 2))
      @pdf_header = pdf_header(params[:title])
      @pdf_footer = pdf_footer
      @pdf_margin = pdf_margin
      render :nothing => true
    end
  end
  
  describe "#pdf_header" do
    context "when online (non-Windows)" do
      before do
        controller.stub!(:ensure_user_in_offline)
        Mode.stub!(:offline?).and_return(false)
        @title = 'Lähtölistat, Äijälä, Örimäki'
        get :index, :title => @title
        @header = assigns[:pdf_header]
      end
      
      it "left should be given title" do
        @header[:left].should == @title
      end
      
      it "right should be current date" do
        @header[:right].should == '02.01.2012'
      end
      
      it "font_size should be 10" do
        @header[:font_size].should == 10
      end
      
      it "spacing should be 10" do
        @header[:spacing].should == 10
      end
    end
    
    context "when offline (Windows)" do
      before do
        Mode.stub!(:offline?).and_return(true)
        @title_original = 'Lähtölistat, Äijälä, Örimäki'
        @title_expected = 'Lahtolistat, Aijala, Orimaki'
        get :index, :title => @title_original
        @header = assigns[:pdf_header]
      end
      
      it "left should be given title without scandinavian alphabets" do
        @header[:left].should == @title_expected
      end
    end
  end
  
  describe "#pdf_footer" do
    before do
      get :index
      @footer = assigns[:pdf_footer]
    end
    specify { @footer[:center].should == 'www.hirviurheilu.com' }
    specify { @footer[:spacing].should == 10 }
    specify { @footer[:line].should be_true }
  end
  
  describe "#pdf_margin" do
    before do
      get :index
      @margin = assigns[:pdf_margin]
    end
    specify { @margin[:top].should == 20 }
    specify { @margin[:bottom].should == 20 }
  end
end
