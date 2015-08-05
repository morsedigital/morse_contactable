require 'spec_helper'

RSpec.describe Addressable, type: :module do

  class Thing < OpenStruct 
    include ActiveModel::Validations
    include Addressable
    def initialize(*args)
      super
    end
    def self.column_names
      []
    end
    def errors_add(sym,text)
      @errors[sym]=text
    end
  end
  class ThingWithNoFields < Thing 
    def self.column_names
      []
    end
  end
  class ThingWithAddress1 < Thing 
    def self.column_names
      %w{address1} 
    end
  end
  class ThingWithPostcode  < Thing
    def self.column_names
      %w{postcode} 
    end
  end
  class ThingWithAllFields < Thing
    def self.column_names
      %w{address1 postcode} 
    end
  end
  class ThingWithAllFieldsAndTitle < ThingWithAllFields
    def title
      "whev"
    end
  end

  let(:address1){"26 Birchington"}
  let(:postcode){"n8 8hp"}
  let(:test_string){"whev"}
  let(:thing){ThingWithAllFields.new(address1: address1,postcode: postcode)}
  describe "validations" do
    context "where the includer has all name fields" do
      context "where all the values are present" do
        let(:thing){ThingWithAllFields.new(address1: "Terry", postcode: "n8 8hp")}
        it "should be_valid", focus: true do
          expect(thing.errors.size).to eq(0)
        end
      end
      context "where a value is missing" do
        let(:thing){ThingWithAllFields.new(address1: "", postcode: "n8 8hp")}
        it "should not be_valid" do
          thing.valid?
          expect(thing.errors.size>0).to be_truthy
        end
      end
    end
    context "where the includer has only address1" do
      let(:thing){ThingWithAddress1.new(address1: "Terry")}
      it "should not be_valid" do
        thing.valid?
        expect(thing.errors.size>0).to be_truthy
      end
    end
    context "where the includer has only postcode" do
      let(:thing){ThingWithPostcode.new(postcode: "Terry")}
      it "should not be_valid" do
        thing.valid?
        expect(thing.errors.size>0).to be_truthy
      end
    end
    context "where the includer has no name fields" do
      let(:thing){ThingWithNoFields.new}
      it "should not be_valid" do
        thing.valid?
        expect(thing.errors.size>0).to be_truthy
      end
    end
  end
end
