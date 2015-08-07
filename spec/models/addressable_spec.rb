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
  let(:thing){ThingWithAllFields.new(address1: address1,postcode: postcode, city: "UK TOWN", zipcode: "haha", state: "kansas")}
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
  describe "instance functions" do
    describe "address_pretty" do 
      it "is a string" do 
        expect(thing.address_pretty).to be_a(String)
      end
    end
    describe "city" do
      it "should return town" do
        expect(thing.city).to eq(thing.town)
      end
    end
    describe "city=" do
      it "should set town" do
        expect(thing.town).to_not eq(test_string)
        thing.city=test_string
        expect(thing.town).to eq(test_string)
      end
    end
    describe "state" do
      it "should return county" do
        expect(thing.state).to eq(thing.county)
      end
    end
    describe "state=" do
      it "should set county" do
        expect(thing.county).to_not eq(test_string)
        thing.state=test_string
        expect(thing.county).to eq(test_string)
      end
    end
    describe "zipcode" do
      it "should return postcode" do
        expect(thing.zipcode).to eq(thing.postcode)
      end
    end
    describe "zipcode=" do
      it "should set postcode" do
        expect(thing.postcode).to_not eq(test_string)
        thing.zipcode=test_string
        expect(thing.postcode).to eq(test_string)
      end
    end
  end
end
