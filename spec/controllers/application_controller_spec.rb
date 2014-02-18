# encoding: UTF-8
require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      Date.stub(:today).and_return(Date.new(2012, 1, 2))
      @pdf_header = pdf_header(params[:title])
      @pdf_footer = pdf_footer
      @pdf_margin = pdf_margin
      render :nothing => true
    end
  end
  
  describe "#pdf_header" do
    before do
      controller.stub(:ensure_user_in_offline)
      @title = 'Lähtölistat, Äijälä, Örimäki'
      @title_expected = 'Lahtolistat, Aijala, Orimaki'
      get :index, :title => @title
      @header = assigns[:pdf_header]
    end
    
    it "left should be given title without scandinavian alphabets" do
      @header[:left].should == @title_expected
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
  
  describe "#path_after_locale_change" do
    context "empty path" do
      it "to fi keeps the empty path" do
        request.stub(:path).and_return('')
        controller.send(:path_after_locale_change, 'fi').should == ''
      end
      
      it "to sv appends sv to the path" do
        request.stub(:path).and_return('')
        controller.send(:path_after_locale_change, 'sv').should == '/sv'
      end
    end

    context "root path" do
      it "to fi keeps the root path" do
        request.stub(:path).and_return('/')
        controller.send(:path_after_locale_change, 'fi').should == '/'
      end
      
      it "to sv appends sv to the path" do
        request.stub(:path).and_return('/')
        controller.send(:path_after_locale_change, 'sv').should == '/sv'
      end
    end

    context "no locale in path" do
      it "to fi does not prepend fi to the path" do
        request.stub(:path).and_return('/prices')
        controller.send(:path_after_locale_change, 'fi').should == '/prices'
      end
      
      it "to sv prepends sv to the path" do
        request.stub(:path).and_return('/prices')
        controller.send(:path_after_locale_change, 'sv').should == '/sv/prices'
      end
    end

    context "fi in path" do
      it "to fi removes fi from the path" do
        request.stub(:path).and_return('/fi/prices')
        controller.send(:path_after_locale_change, 'fi').should == '/prices'
      end

      it "to sv replaces fi to sv in the path" do
        request.stub(:path).and_return('/fi/prices')
        controller.send(:path_after_locale_change, 'sv').should == '/sv/prices'
      end
    end

    context "sv in path" do
      it "to fi removes sv from the path" do
        request.stub(:path).and_return('/sv/prices')
        controller.send(:path_after_locale_change, 'fi').should == '/prices'
      end
      
      it "to sv keeps the path the same" do
        request.stub(:path).and_return('/sv/prices')
        controller.send(:path_after_locale_change, 'sv').should == '/sv/prices'
      end
    end
  end
end
