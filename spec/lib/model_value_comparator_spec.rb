require 'spec_helper'
require 'model_value_comparator'

describe ModelValueComparator do
  describe "values_equal?" do
    before do
      @model = DummyModel.new
    end
    
    it "should return true when no old values defined" do
      @model.values_equal?.should be_true
    end
    
    it "should return true when empty hash of old values defined" do
      @model.old_values = {}
      @model.values_equal?.should be_true
    end
    
    it "should return true when database and old values are nil" do
      @model.db_value = nil
      @model.old_values = { :some_value => nil }
      @model.values_equal?.should be_true
    end
    
    it "should return true when database value is nil and old value is ''" do
      @model.db_value = nil
      @model.old_values = { :some_value => '' }
      @model.values_equal?.should be_true
    end
    
    it "should return false when database value is not nil but old value is" do
      @model.db_value = 10
      @model.old_values = { :some_value => nil }
      @model.values_equal?.should be_false
    end
    
    it "should return false when database value is nil but the old value is not" do
      @model.db_value = nil
      @model.old_values = { :some_value => 15 }
      @model.new_value = 10
      @model.values_equal?.should be_false
    end
    
    it "should return false when database and old values differ" do
      @model.db_value = 16
      @model.old_values = { :some_value => 15 }
      @model.new_value = 14
      @model.values_equal?.should be_false
    end
    
    it "should return true when old and database values differ but new value equals the database value" do
      @model.db_value = 20
      @model.old_values = { :some_value => 5 }
      @model.new_value = 20
      @model.values_equal?.should be_true
    end
  end
  
  class DummyModel
    include ModelValueComparator
    
    attr_accessor :old_values
    
    def db_value=(value)
      @some_value_was = value
    end
    
    def some_value_was
      @some_value_was
    end
    
    def new_value=(value)
      @some_value = value
    end
    
    def some_value
      @some_value
    end
  end
end
