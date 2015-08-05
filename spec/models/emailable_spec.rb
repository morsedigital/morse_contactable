require 'spec_helper'

RSpec.describe Emailable, type: :module do

  class Thing < OpenStruct 
    include ActiveModel::Validations
    include Emailable
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
  class ThingWithAllFields < Thing
    def self.column_names
      %w{email} 
    end
  end
  class ThingWithAllFieldsAndTitle < ThingWithAllFields
    def title
      "whev"
    end
  end

  let(:email){"fred@morsedigital.com"}
  let(:thing){ThingWithAllFields.new(email: email)}
  describe "validations" do
    context "where the includer has all name fields" do
      context "where all the values are present" do
        let(:thing){ThingWithAllFields.new(email: "fred@morsedigital.com")}
        it "should be_valid" do
          expect(thing.errors.size).to eq(0)
        end
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
