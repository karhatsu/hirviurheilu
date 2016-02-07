require 'spec_helper'

describe ProductionEnvironment do
  describe '.name' do
    describe 'in production' do
      before do
        allow(Rails).to receive(:env).and_return('production')
      end

      it 'production' do
        expect(ProductionEnvironment).to receive(:staging?).and_return(false)
        expect(ProductionEnvironment.name).to eql('production')
      end

      it 'staging' do
        expect(ProductionEnvironment).to receive(:staging?).and_return(true)
        expect(ProductionEnvironment.name).to eql('staging')
      end
    end

    describe 'not in production' do
      before do
        allow(Rails).to receive(:env).and_return('test')
        expect(ProductionEnvironment).to receive(:staging?).and_return(false)
      end

      it 'test' do
        expect(ProductionEnvironment.name).to eql('test')
      end
    end
  end
end