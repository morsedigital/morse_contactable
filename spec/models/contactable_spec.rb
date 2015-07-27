require 'spec_helper'

RSpec.describe Contactable, type: :module do

  describe "REQUIRED_DATABASE_FIELDS" do 
    class KlassWithNoContactableFields
      def self.column_names
        %w{name} 
      end
    end
    class KlassWithSomeContactableFields
      def self.column_names
        ["phone"]
      end
    end
    class KlassWithAllContactableFields
      def self.column_names
        Contactable::Email::REQUIRED_DATABASE_FIELDS + Contactable::Address::REQUIRED_DATABASE_FIELDS + Contactable::Phone::REQUIRED_DATABASE_FIELDS
      end
    end
    describe "KlassWithSomeContactableFields" do 
      it "raises RuntimeError: address1 not included. please ensure necessary fields are in place" do 
        expect{KlassWithSomeContactableFields.include Contactable}.to raise_error(RuntimeError, "address1 not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithAllContactableFields" do 
      it "doesnt raise error" do 
        expect{KlassWithAllContactableFields.include Contactable}.to_not raise_error
      end   
    end
  end
  describe "load_required_attributes" do 
    class KlassWithSomeValidations
      def self.column_names
        Contactable::Email::REQUIRED_DATABASE_FIELDS + Contactable::Address::REQUIRED_DATABASE_FIELDS + Contactable::Phone::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      [Contactable::Email::REQUIRED_DATABASE_FIELDS + Contactable::Address::REQUIRED_DATABASE_FIELDS + Contactable::Phone::REQUIRED_DATABASE_FIELDS].flatten.each { |x| attr_accessor x }
      include Contactable
      validate_required_attributes
    end
    describe KlassWithSomeValidations do 
      [Contactable::VALIDATE_EMAILABLE + Contactable::VALIDATE_PHONEABLE + Contactable::VALIDATE_ADDRESSABLE].flatten.each do |x|
        it { is_expected.to validate_presence_of(x) }
      end
    end
  end
end
