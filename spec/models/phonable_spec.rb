require 'spec_helper'

RSpec.describe Contactable::Phone, type: :module do

  describe "REQUIRED_DATABASE_FIELDS" do 
    class KlassWithNoPhonableFields
      def self.column_names
        %w{name} 
      end
    end
    class KlassWithSomePhonableFields
      def self.column_names
        ["phone"]
      end
    end
    class KlassWithAllPhonableFields
      def self.column_names
        Contactable::Phone::REQUIRED_DATABASE_FIELDS
      end
    end
    describe "KlassWithNoPhonableFields" do 
      it "raises RuntimeError RuntimeError: phone not included. please ensure necessary fields are in place" do 
        expect{KlassWithNoPhonableFields.include Contactable::Phone}.to raise_error(RuntimeError, "phone not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithSomePhonableFields" do 
      it "raises RuntimeError: mobile not included. please ensure necessary fields are in place" do 
        expect{KlassWithSomePhonableFields.include Contactable::Phone}.to raise_error(RuntimeError, "mobile not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithAllPhonableFields" do 
      it "doesnt raise error" do 
        expect{KlassWithAllPhonableFields.include Contactable::Phone}.to_not raise_error
      end   
    end
  end
  describe "load_required_attributes" do 
    class KlassWithSomeValidations
      def self.column_names
        Contactable::Phone::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Phone::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Phone
      validate_required_attributes
    end
    describe KlassWithSomeValidations do 
      it { is_expected.to validate_presence_of(:phone) }
      it { is_expected.to_not validate_presence_of(:mobile) } 
    end
  end
end
