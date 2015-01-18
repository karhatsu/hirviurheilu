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

  describe '#set_variant' do
    context 'when forced variant' do
      it 'does not set any other variant' do
        expect(controller).to receive(:set_forced_variant).and_return(true)
        controller.send(:set_variant)
        expect(controller).not_to receive(:request)
      end
    end

    context 'when variant not forced' do
      let(:request) { double }

      before do
        expect(controller).to receive(:set_forced_variant).and_return(false)
        allow(controller).to receive(:request).and_return(request)
      end

      it 'user agent iPhone sets mobile variant' do
        expect_user_agent('Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16')
        expect_mobile_variant
        controller.send(:set_variant)
      end

      it 'user agent iPad does not set mobile variant' do
        expect_user_agent('Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10')
        expect_no_mobile_variant
        controller.send(:set_variant)
      end

      it 'user agent for an Android phone sets mobile variant' do
        expect_user_agent('Mozilla/5.0 (Linux; U; Android 2.2; en-us; SCH-I800 Build/FROYO) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1')
        expect_mobile_variant
        controller.send(:set_variant)
      end

      it 'user agent for an Android tablet does not set mobile variant' do
        expect_user_agent('Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13')
        expect_no_mobile_variant
        controller.send(:set_variant)
      end

      def expect_user_agent(user_agent)
        allow(request).to receive(:user_agent).and_return(user_agent)
      end

      def expect_mobile_variant
        expect(request).to receive(:variant=).with(:mobile)
      end

      def expect_no_mobile_variant
        expect(request).not_to receive(:variant=).with(:mobile)
      end
    end
  end
end
