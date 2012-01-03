require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      @pdf_footer = pdf_footer
      @pdf_margin = pdf_margin
      render :nothing => true
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
