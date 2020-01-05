require 'spec_helper'

describe ApplicationController, type: :controller do
  before do
    allow(Date).to receive(:today).and_return(Date.new(2012, 1, 2))
  end

  controller do
    def index
      @pdf_header = pdf_header(params[:title])
      @pdf_footer = pdf_footer
      @pdf_margin = pdf_margin
      head :ok
    end
  end

  describe "#pdf_header" do
    before do
      @title = 'Lähtölistat, Äijälä, Örimäki'
      @title_expected = 'Lahtolistat, Aijala, Orimaki'
      get :index, params: {title: @title}
      @header = assigns[:pdf_header]
    end

    it "left should be given title without scandinavian alphabets" do
      expect(@header[:left]).to eq(@title_expected)
    end

    it "right should be current date" do
      expect(@header[:right]).to eq('02.01.2012')
    end

    it "font_size should be 10" do
      expect(@header[:font_size]).to eq(10)
    end

    it "spacing should be 10" do
      expect(@header[:spacing]).to eq(10)
    end
  end

  describe "#pdf_footer" do
    before do
      get :index
      @footer = assigns[:pdf_footer]
    end
    specify { expect(@footer[:center]).to eq('www.hirviurheilu.com') }
    specify { expect(@footer[:spacing]).to eq(10) }
    specify { expect(@footer[:line]).to be_truthy }
  end

  describe "#pdf_margin" do
    before do
      get :index
      @margin = assigns[:pdf_margin]
    end
    specify { expect(@margin[:top]).to eq(20) }
    specify { expect(@margin[:bottom]).to eq(20) }
  end

  describe "#path_after_locale_change" do
    context "empty path" do
      it "to fi keeps the empty path" do
        allow(request).to receive(:path).and_return('')
        expect(controller.send(:path_after_locale_change, 'fi')).to eq('')
      end

      it "to sv appends sv to the path" do
        allow(request).to receive(:path).and_return('')
        expect(controller.send(:path_after_locale_change, 'sv')).to eq('/sv')
      end
    end

    context "root path" do
      it "to fi keeps the root path" do
        allow(request).to receive(:path).and_return('/')
        expect(controller.send(:path_after_locale_change, 'fi')).to eq('/')
      end

      it "to sv appends sv to the path" do
        allow(request).to receive(:path).and_return('/')
        expect(controller.send(:path_after_locale_change, 'sv')).to eq('/sv')
      end
    end

    context "no locale in path" do
      it "to fi does not prepend fi to the path" do
        allow(request).to receive(:path).and_return('/prices')
        expect(controller.send(:path_after_locale_change, 'fi')).to eq('/prices')
      end

      it "to sv prepends sv to the path" do
        allow(request).to receive(:path).and_return('/prices')
        expect(controller.send(:path_after_locale_change, 'sv')).to eq('/sv/prices')
      end
    end

    context "fi in path" do
      it "to fi removes fi from the path" do
        allow(request).to receive(:path).and_return('/fi/prices')
        expect(controller.send(:path_after_locale_change, 'fi')).to eq('/prices')
      end

      it "to sv replaces fi to sv in the path" do
        allow(request).to receive(:path).and_return('/fi/prices')
        expect(controller.send(:path_after_locale_change, 'sv')).to eq('/sv/prices')
      end
    end

    context "sv in path" do
      it "to fi removes sv from the path" do
        allow(request).to receive(:path).and_return('/sv/prices')
        expect(controller.send(:path_after_locale_change, 'fi')).to eq('/prices')
      end

      it "to sv keeps the path the same" do
        allow(request).to receive(:path).and_return('/sv/prices')
        expect(controller.send(:path_after_locale_change, 'sv')).to eq('/sv/prices')
      end
    end
  end
end
