require 'spec_helper'

RSpec.describe Phoneable, type: :module do

  class Thing < OpenStruct 
    include ActiveModel::Validations
    include Phoneable
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
  class ThingWithPhone < Thing 
    def self.column_names
      %w{phone} 
    end
  end
  class ThingWithMobile  < Thing
    def self.column_names
      %w{mobile} 
    end
  end
  class ThingWithAllFields < Thing
    def self.column_names
      %w{phone mobile} 
    end
  end
  class ThingWithAllFieldsAndTitle < ThingWithAllFields
    def title
      "whev"
    end
  end

  let(:phone){"26 Birchington"}
  let(:mobile){"n8 8hp"}
  let(:test_string){"whev"}
  let(:thing){ThingWithAllFields.new(phone: phone,mobile: mobile)}
  describe "validations" do
    context "where the includer has all name fields" do
      context "where all the values are present" do
        let(:thing){ThingWithAllFields.new(phone: "26 Birchington", mobile: "n8 8hp")}
        it "should be_valid" do
          expect(thing.errors.size).to eq(0)
        end
      end
      context "where a value is missing" do
        let(:thing){ThingWithAllFields.new(phone: "", mobile: "n8 8hp")}
        it "should not be_valid" do
          thing.valid?
          expect(thing.errors.size>0).to be_truthy
        end
      end
    end
    context "where the includer has only phone" do
      let(:thing){ThingWithPhone.new(phone: "Terry")}
      it "should not be_valid" do
        thing.valid?
        expect(thing.errors.size>0).to be_truthy
      end
    end
    context "where the includer has only mobile" do
      let(:thing){ThingWithMobile.new(mobile: "Terry")}
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
